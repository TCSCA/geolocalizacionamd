import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocalizacionamd/app/core/controllers/doctor_care_controller.dart';
import 'package:geolocalizacionamd/app/core/controllers/login_controller.dart';
import 'package:geolocalizacionamd/app/core/controllers/menu_controller.dart';
import 'package:geolocalizacionamd/app/environments/environment.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/bloc/login_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import 'app/core/controllers/save_data_storage.dart';
import 'app/pages/routes/geoamd_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/pages/sources/main/bloc/main_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, sound: true, badge: true);
  String? tokenFirebaseRegister = await FirebaseMessaging.instance.getToken(
      vapidKey:
          'BM07FHl26hrq8ezg-zRsT0uqdSAGqtO-jeA6Pvsg1rEBtzQCEwUPnmWOlPOt3s7XzbDrbB1RTm-_OQWPWAIoUVc');
  if (kDebugMode) {
    print('tokenFirebaseRegister: $tokenFirebaseRegister');
  }
  await SaveDataStorage().writeDataStorage(tokenFirebaseRegister!);

  const String environment = String.fromEnvironment(
      AppConstants.environmentVariableName,
      defaultValue: Environment.dev);
  Environment().initConfig(environment);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        })
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
  print('Handling a background message ${message.messageId}');
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
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}
