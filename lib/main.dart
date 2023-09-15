import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:geolocalizacionamd/app/pages/sources/profile/bloc/profile_bloc.dart';
import 'package:geolocalizacionamd/app/shared/image_build/bloc/image_profile_bloc.dart';
import '/app/core/controllers/doctor_care_controller.dart';
import '/app/core/controllers/login_controller.dart';
import '/app/core/controllers/menu_controller.dart';
import '/app/environments/environment.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/sources/login/bloc/login_bloc.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/core/controllers/save_data_storage.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/main/bloc/main_bloc.dart';
import 'app/core/controllers/profile_controller.dart';
import 'app/shared/digital_signature_bloc/digital_signature_bloc.dart';
import 'app/themes/geoamd_theme.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as timezone;
import 'package:timezone/timezone.dart' as timezone;

int id = 0;

class NotificationApi {
  static final _notification = FlutterLocalNotificationsPlugin();

  static void init() {
    _notification.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('ic_launcher_foreground'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  static scheduleNotification() async {
    timezone.initializeTimeZones();
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default_notifications_channels',
      'default_notifications_channels',
      channelDescription: 'channel description',
      importance: Importance.max, // set the importance of the notification
      priority: Priority.high, // set prority
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.zonedSchedule(
      id,
      "notification title",
      'Message goes here',
      timezone.TZDateTime.now(timezone.local).add(const Duration(seconds: 5)),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static pushNotification(
    RemoteMessage message,
  ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channed id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _notification.show(id, message.notification!.title,
        message.notification!.body, platformChannelSpecifics);
  }
}

void main() async {
  const String environment = String.fromEnvironment(
      AppConstants.environmentVariableName,
      defaultValue: AppConstants.environmentDevelopment);
  Environment().initConfig(environment);

  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, sound: true, badge: true);
  String? tokenFirebaseRegister = await FirebaseMessaging.instance
      .getToken(vapidKey: Environment().config.idAppMessagingFirebase);
  if (kDebugMode) {
    print('tokenFirebaseRegister: $tokenFirebaseRegister');
  }
  await SaveDataStorage().writeDataStorage(tokenFirebaseRegister!);

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) {
          return LoginBloc(
              loginController: LoginController(),
              menuController: MenuAppController());
        }),
        BlocProvider(
            create: (BuildContext context) =>
                ProfileBloc(getProfileController: ProfileController())),
        BlocProvider(create: (BuildContext context) {
          return NavigationBloc();
        }),
        BlocProvider(create: (BuildContext context) {
          return MainBloc(doctorCareController: DoctorCareController());
        }),
        BlocProvider(create: (BuildContext context) {
          return ImageProfileBloc();
        }),
        BlocProvider(create: (context) => DigitalSignatureBloc())
      ],
      child: MaterialApp.router(
        theme: AppThemes().themedata,
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
      ),
    );
  }
}

bool isFlutterLocalNotificationsInitialized = false;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (kDebugMode) {
    print('Handling a background message ${message.messageId}');
  }
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((event) async {
    await NotificationApi.pushNotification(event);
  });
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          channelDescription: channel.description,
          icon: android.smallIcon,
        ),
      ),
    );
  }
}
