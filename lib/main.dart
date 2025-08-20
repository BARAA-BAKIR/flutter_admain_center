import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admain_center/data/datasources/center_maneger_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/notifications_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
import 'package:flutter_admain_center/data/repositories/center_maneger_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/notifications_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/super_admin_repository_impl.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/features/auth/view/role_router_screen.dart';
import 'package:flutter_admain_center/features/center_manager/bloc/mosques_bloc/mosques_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

// شاشات
import 'package:flutter_admain_center/features/welcome/view/welcome_screen.dart';
import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/main_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/reset_password_screen.dart';

// الثوابت
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/services/notification_service.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

// DataSources
import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';

// Repositories
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/data/repositories/auth_repository_impl.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/data/repositories/teacher_repository_impl.dart';

// UseCases
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';

// Blocs
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/bloc/login_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/dashboard/dashboard_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/myhalaqa/halaqa_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/profile_teacher/profile_bloc.dart';
import 'package:flutter_admain_center/features/teacher/bloc/settings/settings_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final NotificationService notificationService = NotificationService();

/// دالة لمعالجة الإشعارات في الخلفية
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    // _setupFirebaseMessaging();
    _initAppLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  /// إعداد إشعارات Firebase
  // void _setupFirebaseMessaging() async {
  //   final messaging = FirebaseMessaging.instance;
  //   await messaging.requestPermission(alert: true, badge: true, sound: true);

  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       NotificationService.display(message);
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //     _handleNotificationNavigation(message.data);
  //   });

  // الحالة 3: المستخدم يضغط على الإشعار والتطبيق مغلق
  // يتم استدعاء هذه الدالة عند فتح التطبيق من إشعار
  //   messaging.getInitialMessage().then((RemoteMessage? message) {
  //     if (message != null) {
  //       print('App opened from a terminated state by a notification!');
  //       _handleNotificationNavigation(message.data);
  //     }
  //   });
  // }

  // void _handleNotificationNavigation(Map<String, dynamic> data) {
  //   // افترض أن الخادم يرسل 'screen' كجزء من بيانات الإشعار
  //   final String? screen = data['screen'];

  //   if (screen == 'notifications') {
  //     // استخدم الـ GlobalKey للانتقال إلى شاشة الإشعارات
  //     navigatorKey.currentState?.push(
  //       MaterialPageRoute(builder: (_) => const NotificationsScreen()),
  //     );
  //   }
  //   // يمكنك إضافة المزيد من الشروط هنا لأنواع أخرى من الإشعارات
  //   // مثال: if (screen == 'halaqa_details') { ... }
  // }

  /// تهيئة الروابط العميقة باستخدام app_links
  Future<void> _initAppLinks() async {
    _appLinks = AppLinks();

    // إذا كان التطبيق مغلق وتم فتحه بالرابط
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _navigateToResetScreen(initialUri);
      }
    } on PlatformException {
      print('Failed to get initial link.');
    }

    // إذا كان التطبيق يعمل وتلقى رابطًا
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _navigateToResetScreen(uri);
    });
  }

  /// التنقل لشاشة إعادة التعيين
  void _navigateToResetScreen(Uri uri) {
    if (uri.path.contains('reset-password')) {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];

      if (token != null && email != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(token: token, email: email),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<NotificationService>(
          create: (_) => NotificationService(),
        ),
        RepositoryProvider<AuthApiDatasource>(
          create: (_) => AuthApiDatasource(),
        ),
        RepositoryProvider<TeacherApiDatasource>(
          create: (_) => TeacherApiDatasource(),
        ),
        RepositoryProvider<TeacherLocalDatasource>(
          create: (_) => TeacherLocalDatasource(),
        ),
        RepositoryProvider<CenterManegerApiDatasource>(
          create: (_) => CenterManegerApiDatasource(),
        ),
        RepositoryProvider<NotificationsApiDatasource>(
          create: (_) => NotificationsApiDatasource(),
        ),
        RepositoryProvider<NotificationsRepository>(
          create:
              (context) => NotificationsRepositoryImpl(
                datasource: context.read<NotificationsApiDatasource>(),
                storage: context.read<FlutterSecureStorage>(),
              ),
        ),
        RepositoryProvider<AuthRepository>(
          create:
              (context) => AuthRepositoryImpl(
                datasource: context.read<AuthApiDatasource>(),
                storage: context.read<FlutterSecureStorage>(),
                localDatasource: context.read<TeacherLocalDatasource>(),
              ),
        ),
        RepositoryProvider<SuperAdminApiDatasource>(
          create: (_) => SuperAdminApiDatasource(),
        ),
        RepositoryProvider<SuperAdminRepository>(
          create:
              (context) => SuperAdminRepositoryImpl(
                datasource: context.read<SuperAdminApiDatasource>(),
                storage: context.read<FlutterSecureStorage>(),
              ),
        ),
        RepositoryProvider<CenterManagerRepository>(
          create:
              (context) => CenterManegerRepositoryImpl(
                datasource: context.read<CenterManegerApiDatasource>(),
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
        RepositoryProvider<LoginUseCase>(
          create:
              (context) =>
                  LoginUseCase(repository: context.read<AuthRepository>()),
        ),
        RepositoryProvider<RegisterTeacherUseCase>(
          create:
              (context) => RegisterTeacherUseCase(
                repository: context.read<AuthRepository>(),
              ),
        ),
        RepositoryProvider<GetCentersUseCase>(
          create:
              (context) =>
                  GetCentersUseCase(repository: context.read<AuthRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                  notificationService: context.read<NotificationService>(),
                )..add(AppStarted()),
          ),
          BlocProvider<LoginBloc>(
            create:
                (context) => LoginBloc(
                  loginUseCase: context.read<LoginUseCase>(),
                  authBloc: context.read<AuthBloc>(),
                ),
          ),
          BlocProvider<DashboardBloc>(
            create:
                (context) => DashboardBloc(
                  teacherRepository: context.read<TeacherRepository>(),
                ),
          ),
          BlocProvider<HalaqaBloc>(
            create:
                (context) => HalaqaBloc(
                  teacherRepository: context.read<TeacherRepository>(),
                  dashboardBloc: context.read<DashboardBloc>(),
                ),
          ),

          BlocProvider<ProfileBloc>(
            create:
                (context) => ProfileBloc(
                  teacherRepository: context.read<TeacherRepository>(),
                ),
          ),
          BlocProvider<SettingsBloc>(
            create:
                (context) =>
                    SettingsBloc(authRepository: context.read<AuthRepository>())
                      ..add(LoadSettings()),
          ),
          //  BlocProvider<HalaqasBloc>(
          //   create: (context) => HalaqasBloc(
          //     repository: context.read<CenterManagerRepository>(),
          //   ),
          // ),

          // // بلوك لإدارة قائمة الأساتذة لمدير المركز
          // BlocProvider<TeachersBloc>(
          //   create: (context) => TeachersBloc(
          //     repository: context.read<CenterManagerRepository>(),
          //   ),
          // ),

          // بلوك لإدارة قائمة المساجد لمدير المركز
          BlocProvider<MosquesBloc>(
            create:
                (context) => MosquesBloc(
                  repository: context.read<CenterManagerRepository>(),
                ),
          ),
        ],
        child: MaterialApp(
          title: 'مركز الإدارة',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          locale: const Locale('ar'),
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
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.steel_blue),
            useMaterial3: true,
          ),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                return const RoleRouterScreen();
              }
              if (state is AuthUnauthenticated) {
                return const LoginScreen();
              }
              // في البداية (AuthInitial)، اعرض شاشة البداية أو التحميل
              return const WelcomeScreen();
            },
          ),
          routes: {
            AppRoutes.welcome: (context) => const WelcomeScreen(),
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.register: (context) => const RegistrationScreen(),
            AppRoutes.mainTeacher: (context) => const MainScreen(),
          },
        ),
      ),
    );
  }
}
