// lib/main.dart
import 'package:flutter_admain_center/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/repositories/teacher_repository_impl.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/features/auth/bloc/login_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/halaqa_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// استيراد الطبقات والملفات اللازمة
import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/data/repositories/auth_repository_impl.dart';
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/main_screen.dart';
import 'package:flutter_admain_center/features/welcome/view/welcome_screen.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

// استيراد ملف تهيئة Firebase
import 'firebase_options.dart';

// --- دالة لمعالجة الإشعارات عندما يكون التطبيق في الخلفية أو مغلق ---
// يجب أن تكون هذه الدالة خارج أي كلاس (Top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // إذا كنت تريد القيام بشيء ما مع الإشعار في الخلفية، يمكنك كتابة الكود هنا.
  // على سبيل المثال، يمكنك تحديث بيانات معينة في التخزين المحلي.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

void main() async {
  // --- التهيئة الأساسية ---
  WidgetsFlutterBinding.ensureInitialized();

  // --- تهيئة Firebase ---
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // --- ربط معالج الإشعارات في الخلفية ---
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
 
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
   late TeacherRepository teacherRepository;

  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  // --- دالة لإعداد كل ما يتعلق بالإشعارات ---
  void _setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // --- 1. طلب صلاحيات الإشعارات من المستخدم (لأجهزة iOS و Android 13+) ---
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // --- 2. الاستماع للإشعارات القادمة والتطبيق في المقدمة (Foreground) ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // هنا يمكنك استخدام flutter_local_notifications لعرض الإشعار
        // أو يمكنك عرض SnackBar أو أي ويدجت أخرى مباشرة
        NotificationService.display(message);
      }
    });

    // --- 3. التعامل مع فتح التطبيق عن طريق الضغط على إشعار (من حالة Terminated) ---
    messaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('App opened from terminated state by notification!');
        // هنا يمكنك توجيه المستخدم إلى شاشة معينة بناءً على بيانات الإشعار
        // مثلاً: Navigator.pushNamed(context, '/notifications', arguments: message.data);
      }
    });

    // --- 4. التعامل مع فتح التطبيق عن طريق الضغط على إشعار (من حالة Background) ---
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from background state by notification!');
      // نفس منطق التوجيه هنا
    });

    // --- 5. الحصول على FCM Token (اختياري لكن مهم) ---
    // هذا هو المعرف الفريد للجهاز الذي سترسله إلى Laravel لتتمكن من إرسال إشعارات لجهاز معين
    final fcmToken = await messaging.getToken();
    print("FCM Token: $fcmToken");
    // TODO: أرسل هذا التوكن إلى سيرفر Laravel الخاص بك وقم بتخزينه مع بيانات المستخدم
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // توفير الخدمات الأساسية
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),

        // توفير مصادر البيانات
        RepositoryProvider<AuthApiDatasource>(
          create: (context) => AuthApiDatasource(),
        ),
        RepositoryProvider<TeacherApiDatasource>(
          create: (context) => TeacherApiDatasource(),
        ),
        RepositoryProvider<TeacherLocalDatasource>(
          create: (context) => TeacherLocalDatasource(),
        ),
      ],
      // نستخدم builder للحصول على context جديد يمكنه رؤية الـ providers في الأعلى
      child: Builder(
        builder: (context) {
          return MultiRepositoryProvider(
            providers: [
              // المستودعات (Repositories)
              RepositoryProvider<AuthRepository>(
                create:
                    (context) => AuthRepositoryImpl(
                      datasource: context.read<AuthApiDatasource>(),
                      storage: context.read<FlutterSecureStorage>(),
                    ),
              ),
              RepositoryProvider<TeacherRepository>(
                create:
                    (context) => TeacherRepositoryImpl(
                      apiDatasource: context.read<TeacherApiDatasource>(),
                      localDatasource: context.read<TeacherLocalDatasource>(),
                      storage: context.read<FlutterSecureStorage>(),
                    ),
              ),

              // حالات الاستخدام (UseCases)
              RepositoryProvider<LoginUseCase>(
                create:
                    (context) => LoginUseCase(
                      repository: context.read<AuthRepository>(),
                    ),
              ),
              // ... باقي الـ UseCases
            ],
            // --- الخطوة 3: توفير الـ Blocs التي تعتمد على المستودعات ---
            child: MultiBlocProvider(
              providers: [
                // الـ Blocs
                BlocProvider<AuthBloc>(
                  create:
                      (context) => AuthBloc(
                        authRepository: context.read<AuthRepository>(),
                      )..add(AppStarted()),
                ),
                BlocProvider<LoginBloc>(
                  create:
                      (context) => LoginBloc(
                        loginUseCase: context.read<LoginUseCase>(),
                        authBloc: context.read<AuthBloc>(),
                      ),
                ),
                // ... باقي الـ Blocs
              ],
              // --- الخطوة 4: بناء واجهة التطبيق ---
              child: MaterialApp(
                title: 'Flutter Admin Center',
                locale: const Locale('ar'),
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                builder: (context, child) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: child!,
                  );
                },
                theme: ThemeData(
                  primaryColor: AppColors.steel_blue,
                  scaffoldBackgroundColor: AppColors.ivory_yellow,
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.steel_blue,
                  ),
                  useMaterial3: true,
                ),
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    teacherRepository = context.read<TeacherRepository>();
                    if (state is AuthAuthenticated) {
                      return BlocProvider(
                        create:
                            (context) =>
                                HalaqaBloc(teacherRepository: teacherRepository)
                                  ..add(FetchHalaqaData()),
                        child: MainScreen(teacherRepository: teacherRepository),
                      );
                    }
                    if (state is AuthUnauthenticated) {
                      return const LoginScreen();
                    }
                    return const WelcomeScreen();
                  },
                ),
                routes: {
                  AppRoutes.welcome: (context) => const WelcomeScreen(),
                  AppRoutes.login: (context) => const LoginScreen(),
                  AppRoutes.register: (context) => const RegistrationScreen(),
                  AppRoutes.mainTeacher: (context) => MainScreen(teacherRepository:teacherRepository ,),
                  // AppRoutes.addstudent: (context) => const AddStudentScreen(),
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
