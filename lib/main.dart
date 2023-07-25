import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:geolocalizacionamd/app/shared/notification/bloc/notifications_bloc.dart';
import 'package:geolocalizacionamd/app/shared/notification/local_notifications.dart';
import '/app/core/controllers/doctor_care_controller.dart';
import '/app/core/controllers/login_controller.dart';
import '/app/core/controllers/menu_controller.dart';
import '/app/environments/environment.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';

void main() async {
  const String environment = String.fromEnvironment(
      AppConstants.environmentVariableName,
      defaultValue: AppConstants.environmentDevelopment);
  Environment().initConfig(environment);

  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await NotificationsBloc.initializeFCM();
  await LocalNotifications.initializeLocalNotifications();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) {
          return LoginBloc(
              loginController: LoginController(),
              menuController: MenuAppController());
        }),
        BlocProvider(create: (BuildContext context) {
          return NavigationBloc();
        }),
        BlocProvider(create: (BuildContext context) {
          return MainBloc(doctorCareController: DoctorCareController());
        }),
        BlocProvider(
          create: (_) {
            return NotificationsBloc(
              requestLocalNotificationPermissions:
                  LocalNotifications.requestPermissionLocalNotifications,
              showLocalNotification: LocalNotifications.showLocalNotification,
            );
          },
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: Environment().config.appName,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppConstants.languageCodeEs),
          Locale(AppConstants.languageCodeEn)
        ],
        locale: const Locale(AppConstants.languageCodeEs),
        routerConfig: GeoAmdRoutes.routerConfig,
        builder: (context, child) =>
            HandleNotificationInteractions(child: child!),
      ),
    );
  }
}

class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationsBloc>().handleRemoteMessage(message);

    final messageId =
        message.messageId?.replaceAll(':', '').replaceAll('%', '');
    GeoAmdRoutes.router.push('/home');
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
