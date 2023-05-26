import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocalizacionamd/app/core/controllers/login_controller.dart';
import 'package:geolocalizacionamd/app/core/controllers/menu_controller.dart';
import 'package:geolocalizacionamd/app/environments/environment.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/bloc/login_bloc.dart';
import 'package:geolocalizacionamd/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import 'app/pages/routes/geoamd_route.dart';

void main() {
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
        })
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale(AppConstants.languageCodeEn), // English
          Locale(AppConstants.languageCodeEs), // Spanish
        ],
        routerConfig: GeoAmdRoutes.routerConfig,
      ),
    );
  }
}
