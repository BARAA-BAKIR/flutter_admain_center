
// import 'dart:async';
// import 'package:app_links/app_links.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_admain_center/core/constants/app_colors.dart';
// import 'package:flutter_admain_center/core/constants/app_routes.dart';
// import 'package:flutter_admain_center/core/services/notification_service.dart';
// import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
// import 'package:flutter_admain_center/data/datasources/center_maneger_api_datasource.dart';
// import 'package:flutter_admain_center/data/datasources/notifications_api_datasource.dart';
// import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
// import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
// import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
// import 'package:flutter_admain_center/data/repositories/auth_repository_impl.dart';
// import 'package:flutter_admain_center/data/repositories/center_maneger_repository_impl.dart';
// import 'package:flutter_admain_center/data/repositories/notifications_repository_impl.dart';
// import 'package:flutter_admain_center/data/repositories/super_admin_repository_impl.dart';
// import 'package:flutter_admain_center/data/repositories/teacher_repository_impl.dart';
// import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
// import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
// import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
// import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
// import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
// import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
// import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
// import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';
// import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
// import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
// import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
// import 'package:flutter_admain_center/features/auth/view/role_router_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/halaqa_types_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/parts_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/progress_stages_screen.dart';
// import 'package:flutter_admain_center/features/super_admin/view/super_admin_dashboard_screen.dart';
// import 'package:flutter_admain_center/features/teacher/view/main_screen.dart';
// import 'package:flutter_admain_center/features/auth/view/reset_password_screen.dart';
// import 'package:flutter_admain_center/features/welcome/view/welcome_screen.dart';
// import 'package:flutter_admain_center/firebase_options.dart';
// import 'package:flutter_admain_center/generated/l10n.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(const App());
// }

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
//         RepositoryProvider<NotificationService>(create: (_) => NotificationService()),
//         RepositoryProvider<AuthApiDatasource>(create: (_) => AuthApiDatasource()),
//         RepositoryProvider<TeacherApiDatasource>(create: (_) => TeacherApiDatasource()),
//         RepositoryProvider<TeacherLocalDatasource>(create: (_) => TeacherLocalDatasource()),
//         RepositoryProvider<CenterManegerApiDatasource>(create: (_) => CenterManegerApiDatasource()),
//         RepositoryProvider<NotificationsApiDatasource>(create: (_) => NotificationsApiDatasource()),
//         RepositoryProvider<SuperAdminApiDatasource>(create: (context) => SuperAdminApiDatasource(context.read<FlutterSecureStorage>())),
//         RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl(datasource: context.read<AuthApiDatasource>(), storage: context.read<FlutterSecureStorage>(), localDatasource: context.read<TeacherLocalDatasource>())),
//         RepositoryProvider<NotificationsRepository>(create: (context) => NotificationsRepositoryImpl(datasource: context.read<NotificationsApiDatasource>(), storage: context.read<FlutterSecureStorage>())),
//         RepositoryProvider<SuperAdminRepository>(create: (context) => SuperAdminRepositoryImpl(datasource: context.read<SuperAdminApiDatasource>(), storage: context.read<FlutterSecureStorage>())),
//         RepositoryProvider<CenterManagerRepository>(create: (context) => CenterManegerRepositoryImpl(datasource: context.read<CenterManegerApiDatasource>(), storage: context.read<FlutterSecureStorage>())),
//         RepositoryProvider<TeacherRepository>(create: (context) => TeacherRepositoryImpl(apiDatasource: context.read<TeacherApiDatasource>(), localDatasource: context.read<TeacherLocalDatasource>(), storage: context.read<FlutterSecureStorage>())),
//         RepositoryProvider<LoginUseCase>(create: (context) => LoginUseCase(repository: context.read<AuthRepository>())),
//         RepositoryProvider<RegisterTeacherUseCase>(create: (context) => RegisterTeacherUseCase(repository: context.read<AuthRepository>())),
//         RepositoryProvider<GetCentersUseCase>(create: (context) => GetCentersUseCase(repository: context.read<AuthRepository>())),
//       ],
//       child: BlocProvider<AuthBloc>(
//         create: (context) => AuthBloc(
//           authRepository: context.read<AuthRepository>(),
//           notificationService: context.read<NotificationService>(),
//         )..add(AppStarted()),
//         child: BlocBuilder<AuthBloc, AuthState>(
//           builder: (context, state) {
//             return AppContent(
//               key: ValueKey(state is AuthAuthenticated),
//               authState: state,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class AppContent extends StatefulWidget {
//   final AuthState authState;
//   const AppContent({super.key, required this.authState});

//   @override
//   State<AppContent> createState() => _AppContentState();
// }

// class _AppContentState extends State<AppContent> {
//   late final AppLinks _appLinks;
//   StreamSubscription<Uri>? _linkSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _initAppLinks();
//   }

//   @override
//   void dispose() {
//     _linkSubscription?.cancel();
//     super.dispose();
//   }

//   Future<void> _initAppLinks() async {
//     _appLinks = AppLinks();
//     try {
//       final initialUri = await _appLinks.getInitialLink();
//       if (initialUri != null) _navigateToResetScreen(initialUri);
//     } on PlatformException {}
//     _linkSubscription = _appLinks.uriLinkStream.listen((uri) => _navigateToResetScreen(uri));
//   }

//   void _navigateToResetScreen(Uri uri) {
//     if (uri.path.contains('reset-password')) {
//       final token = uri.queryParameters['token'];
//       final email = uri.queryParameters['email'];
//       if (token != null && email != null) {
//         navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => ResetPasswordScreen(token: token, email: email)));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ✅ الحل: أضفنا BlocListener هنا للتحكم في التوجيه العام
//     return BlocListener<AuthBloc, AuthState>(
//       listener: (context, state) {
//         // عندما تتم المصادقة بنجاح
//         if (state is AuthAuthenticated) {
//           // انتقل إلى شاشة الأدوار واحذف كل الشاشات السابقة
//           navigatorKey.currentState?.pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const RoleRouterScreen()),
//             (route) => false,
//           );
//         }
//         // عند تسجيل الخروج
//         else if (state is AuthUnauthenticated) {
//           // انتقل إلى شاشة الترحيب واحذف كل الشاشات السابقة
//           navigatorKey.currentState?.pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//             (route) => false,
//           );
//         }
//       },
//       child: MaterialApp(
//         title: 'مركز الإدارة',
//         debugShowCheckedModeBanner: false,
//         navigatorKey: navigatorKey,
//         locale: const Locale('ar'),
//         localizationsDelegates: const [S.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
//         supportedLocales: S.delegate.supportedLocales,
//         builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
//         theme: ThemeData(
//            pageTransitionsTheme: const PageTransitionsTheme(
//           builders: {
//             TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
//             TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//           },),
//           primaryColor: AppColors.steel_blue,
//           scaffoldBackgroundColor: const Color(0xFFF0F4F8),
//           colorScheme: ColorScheme.fromSeed(seedColor: AppColors.steel_blue),
//           useMaterial3: true,
//         ),
//         // الشاشة الابتدائية تعتمد على الحالة الأولية فقط
//         home: widget.authState is AuthAuthenticated ? const RoleRouterScreen() : const WelcomeScreen(),
//         routes: {
//           AppRoutes.welcome: (context) => const WelcomeScreen(),
//           AppRoutes.login: (context) => const LoginScreen(),
//           AppRoutes.register: (context) => const RegistrationScreen(),
//           AppRoutes.mainTeacher: (context) => const MainScreen(),
//           '/super-admin/dashboard': (context) => const SuperAdminDashboardScreen(),
//           '/super-admin/halaqa-types': (context) => const HalaqaTypesScreen(),
//           '/super-admin/progress-stages': (context) => const ProgressStagesScreen(),
//           '/super-admin/parts': (context) => const PartsScreen(),
//         },
//       ),
//     );
//   }
// }

//////////
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admain_center/core/constants/app_colors.dart';
import 'package:flutter_admain_center/core/constants/app_routes.dart';
import 'package:flutter_admain_center/core/services/notification_service.dart';
import 'package:flutter_admain_center/data/datasources/auth_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/center_maneger_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/notifications_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/super_admin_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_api_datasource.dart';
import 'package:flutter_admain_center/data/datasources/teacher_local_datasource.dart';
import 'package:flutter_admain_center/data/repositories/auth_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/center_maneger_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/notifications_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/super_admin_repository_impl.dart';
import 'package:flutter_admain_center/data/repositories/teacher_repository_impl.dart';
import 'package:flutter_admain_center/domain/repositories/auth_repository.dart';
import 'package:flutter_admain_center/domain/repositories/center_maneger_repository.dart';
import 'package:flutter_admain_center/domain/repositories/notifications_repository.dart';
import 'package:flutter_admain_center/domain/repositories/super_admin_repository.dart';
import 'package:flutter_admain_center/domain/repositories/teacher_repository.dart';
import 'package:flutter_admain_center/domain/usecases/get_centers_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/login_usecase.dart';
import 'package:flutter_admain_center/domain/usecases/register_teacher_usecase.dart';
import 'package:flutter_admain_center/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_admain_center/features/auth/view/login_screen.dart';
import 'package:flutter_admain_center/features/auth/view/registration_screen.dart';
import 'package:flutter_admain_center/features/auth/view/role_router_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/halaqa_types_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/parts_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/progress_stages_screen.dart';
import 'package:flutter_admain_center/features/super_admin/view/super_admin_dashboard_screen.dart';
import 'package:flutter_admain_center/features/teacher/view/main_screen.dart';
import 'package:flutter_admain_center/features/auth/view/reset_password_screen.dart';
import 'package:flutter_admain_center/features/welcome/view/welcome_screen.dart';
import 'package:flutter_admain_center/firebase_options.dart';
import 'package:flutter_admain_center/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
        RepositoryProvider<NotificationService>(create: (_) => NotificationService()),
        RepositoryProvider<AuthApiDatasource>(create: (_) => AuthApiDatasource()),
        RepositoryProvider<TeacherApiDatasource>(create: (_) => TeacherApiDatasource()),
        RepositoryProvider<TeacherLocalDatasource>(create: (_) => TeacherLocalDatasource()),
        RepositoryProvider<CenterManegerApiDatasource>(create: (_) => CenterManegerApiDatasource()),
        RepositoryProvider<NotificationsApiDatasource>(create: (_) => NotificationsApiDatasource()),
        RepositoryProvider<SuperAdminApiDatasource>(create: (context) => SuperAdminApiDatasource(context.read<FlutterSecureStorage>())),
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepositoryImpl(datasource: context.read<AuthApiDatasource>(), storage: context.read<FlutterSecureStorage>(), localDatasource: context.read<TeacherLocalDatasource>())),
        RepositoryProvider<NotificationsRepository>(create: (context) => NotificationsRepositoryImpl(datasource: context.read<NotificationsApiDatasource>(), storage: context.read<FlutterSecureStorage>())),
        RepositoryProvider<SuperAdminRepository>(create: (context) => SuperAdminRepositoryImpl(datasource: context.read<SuperAdminApiDatasource>())),
        RepositoryProvider<CenterManagerRepository>(create: (context) => CenterManegerRepositoryImpl(datasource: context.read<CenterManegerApiDatasource>(), storage: context.read<FlutterSecureStorage>())),
        RepositoryProvider<TeacherRepository>(create: (context) => TeacherRepositoryImpl(apiDatasource: context.read<TeacherApiDatasource>(), localDatasource: context.read<TeacherLocalDatasource>(), storage: context.read<FlutterSecureStorage>())),
        RepositoryProvider<LoginUseCase>(create: (context) => LoginUseCase(repository: context.read<AuthRepository>())),
        RepositoryProvider<RegisterTeacherUseCase>(create: (context) => RegisterTeacherUseCase(repository: context.read<AuthRepository>())),
        RepositoryProvider<GetCentersUseCase>(create: (context) => GetCentersUseCase(repository: context.read<AuthRepository>())),
      ],
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepository>(),
          notificationService: context.read<NotificationService>(),
        )..add(AppStarted()),
        child: const AppContent(),
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.host == 'reset-password') {
      final token = uri.queryParameters['token'];
      final email = uri.queryParameters['email'];
      if (token != null && email != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.resetPassword,
            arguments: {'token': token, 'email': email},
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مركز الإدارة',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      // --- ✅ التعديل للمحاذاة العربية ---
      locale: const Locale('ar'),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      // --- ✅ التعديل للمحاذاة العربية ---
      builder: (context, child) {
        // الـ BlocListener يبقى هنا للتحكم بالدخول والخروج
        final listener = BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RoleRouterScreen()),
                (route) => false,
              );
            } else if (state is AuthUnauthenticated) {
              navigatorKey.currentState?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            }
          },
          child: child!,
        );
        // تغليف التطبيق بـ Directionality لفرض الاتجاه من اليمين لليسار
        return Directionality(
          textDirection: TextDirection.rtl,
          child: listener,
        );
      },
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        primaryColor: AppColors.steel_blue,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.steel_blue),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      routes: {
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegistrationScreen(),
        AppRoutes.mainTeacher: (context) => const MainScreen(),
        '/super-admin/dashboard': (context) => const SuperAdminDashboardScreen(),
        '/super-admin/halaqa-types': (context) => const HalaqaTypesScreen(),
        '/super-admin/progress-stages': (context) => const ProgressStagesScreen(),
        '/super-admin/parts': (context) => const PartsScreen(),
        AppRoutes.resetPassword: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return ResetPasswordScreen(
            token: args['token']!,
            email: args['email']!,
          );
        },
      },
    );
  }
}
