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
            menuController: MenuAppController(),
          );
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
