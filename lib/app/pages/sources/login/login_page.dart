import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/renew_password/renew_password_page.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';
import 'package:local_auth/local_auth.dart';

import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> userFieldKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormFieldState> passwordFieldKey =
      GlobalKey<FormFieldState>();
  TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _visiblePassword = false;
  bool? _userRemenber = false;

  @override
  void initState() {
    initSessionUserSave();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff2B5178), Color(0xff273456)],
          begin: Alignment(0.0, 0.0),
          end: Alignment(0.25, 0.75),
        )),
        child: SafeArea(
            child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginShowLoadingState) {
              LoadingBuilder(context).showLoadingIndicator(
                  context.appLocalization.titleLoginLoading);
            }
            if (state is LoginSuccessState) {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              final bool? userSave = prefs.getBool('userSave');

              if (userSave != null && userSave == true) {
                await prefs.setString('user_key', userController.text.trim());
                await prefs.setString(
                    'password_key', passwordController.text.trim());
              }

              LoadingBuilder(context).hideOpenDialog();
              context.go(GeoAmdRoutes.home, extra: NavigationBloc());
            }
            if (state is LoginErrorState) {
              LoadingBuilder(context).hideOpenDialog();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: AppMessages()
                          .getMessageTitle(context, AppConstants.statusError),
                      descriptions:
                          AppMessages().getMessage(context, state.message),
                      isConfirmation: false,
                      dialogAction: () {},
                      type: AppConstants.statusError,
                    );
                  });
            }
            if (state is LoginActiveState) {
              LoadingBuilder(context).hideOpenDialog();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: AppMessages()
                          .getMessageTitle(context, AppConstants.statusWarning),
                      descriptions:
                          AppMessages().getMessage(context, state.message),
                      isConfirmation: true,
                      dialogAction: () => BlocProvider.of<LoginBloc>(context)
                          .add(ProcessResetLoginEvent(
                              userController.text,
                              passwordController.text,
                              context.localization.languageCode)),
                      type: AppConstants.statusWarning,
                    );
                  });
            }
          },
          child: Form(
              key: loginFormKey,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*Flexible(
                      child:*/
                    Image.asset(
                      'assets/images/gps_doctor_image.png',
                      width: 340,
                      height: 210,
                    ),
                    // ),
                    /* Flexible(
                        child: */
                    Image.asset(
                      'assets/images/telemedicina24_logo_blanco_lineal.png',
                      width: 350,
                      height: 90,
                    ),
                    // ),
                    const SizedBox(height: 30.0),
                    if (_userRemenber! &&
                        userNameSave != null &&
                        userNameSave != '')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bienvenido $userNameSave',
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'TitlesHighlight'),
                        ),
                      ),
                    if (userNameSave == null || userNameSave == '')
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            key: userFieldKey,
                            controller: userController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                fillColor:
                                    const Color(0xffD84835).withAlpha(50),
                                hintText: 'Usuario',
                                hintStyle: const TextStyle(
                                    color: Color(0xffFFFFFF),
                                    fontSize: 19.0,
                                    fontFamily: 'TitlesHighlight'),
                                prefixIcon: const Icon(
                                  FontAwesomeIcons.userDoctor,
                                  color: Color(0xffFFFFFF),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xffFFFFFF), width: 2),
                                    borderRadius: BorderRadius.circular(30.0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xffFFFFFF), width: 2),
                                    borderRadius: BorderRadius.circular(30.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xffE3D3B2), width: 3),
                                    borderRadius: BorderRadius.circular(30.0)),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                errorStyle: const TextStyle(
                                    color: Color(0xffD84835),
                                    fontSize: 14.0,
                                    fontFamily: 'TextsParagraphs')),
                            style: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 19.0,
                                fontFamily: 'TitlesHighlight'),
                            validator: (fieldValue) {
                              if (fieldValue!.isEmpty) {
                                return 'No puede ser vacio';
                              }
                              if (fieldValue.length < 5) {
                                return 'Tamaño no valido';
                              }
                              return null;
                            }),
                      ),
                   // const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                          key: passwordFieldKey,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: _visiblePassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _visiblePassword = !_visiblePassword;
                                  setState(() {});
                                },
                                icon: Icon(
                                  !_visiblePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                              ),
                              fillColor: const Color(0xffD84835).withAlpha(50),
                              hintText: 'Clave',
                              hintStyle: const TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontSize: 19.0,
                                  fontFamily: 'TitlesHighlight'),
                              prefixIcon: const Icon(
                                FontAwesomeIcons.lock,
                                color: Color(0xffFFFFFF),
                              ),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffFFFFFF), width: 2),
                                  borderRadius: BorderRadius.circular(30.0)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffFFFFFF), width: 2),
                                  borderRadius: BorderRadius.circular(30.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xffE3D3B2), width: 3),
                                  borderRadius: BorderRadius.circular(30.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              errorStyle: const TextStyle(
                                  color: Color(0xffD84835),
                                  fontSize: 14.0,
                                  fontFamily: 'TextsParagraphs')),
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 19.0,
                              fontFamily: 'TitlesHighlight'),
                          validator: (fieldValue) {
                            if (fieldValue!.isEmpty) {
                              return 'No puede ser vacio';
                            }
                            if (fieldValue.length < 5) {
                              return 'Tamaño no valido';
                            }
                            return null;
                          }),
                    ),
                    // const SizedBox(height: 10.0),
                    Theme(
                      data: ThemeData(
                        primarySwatch: null,
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Switch(
                              //thumbIcon: thumbIcon,
                              activeColor: Colors.red,
                              value: _userRemenber!,
                              onChanged: (value) async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                if (value!) {
                                  await prefs.setBool('userSave', value);
                                } else {
                                  await prefs.remove('userSave');
                                  await prefs.remove('user_key');
                                  await prefs.remove('password_key');
                                  userController.clear();

                                  userNameSave = '';
                                }
                                _userRemenber = value;
                                setState(() {});
                              }),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              _userRemenber!
                                  ? userNameSave != '' ? 'No soy $userNameSave' : 'Recordar Contraseña'
                                  : 'Recordar Contraseña',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Theme(
                      data: ThemeData(
                        primarySwatch: null,
                        unselectedWidgetColor: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Text(
                              'Usar Autenticación biométrica',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Checkbox(value: false, onChanged: (value) {}),
                        ],
                      ),
                    ),*/
                    const SizedBox(height: 30.0),
                    Container(
                      height: 100,
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  elevation: 5,
                                  side: const BorderSide(
                                      width: 2, color: Color(0xffFFFFFF)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () async {
                                bool aut = await LocalAuthentication()
                                    .canCheckBiometrics;
                                if (!loginFormKey.currentState!.validate()) {
                                  return;
                                } else {
                                  final String languageCode =
                                      context.localization.languageCode;
                                  BlocProvider.of<LoginBloc>(context).add(
                                    ProcessLoginEvent(userController.text,
                                        passwordController.text, languageCode),
                                  );
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffF96352),
                                        Color(0xffD84835)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 40),
                                  child: const Text(
                                    'Ingresar',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'TitlesHighlight',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (fingerPrintTrue)
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              height: 70,
                              width: 70,
                              alignment: Alignment.center,
                              child: IconButton(
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                onPressed: () async {
                                  final valuee = await LocalAuthentication()
                                      .getAvailableBiometrics();

                                  final valueeee = BiometricType.fingerprint;
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  try {
                                    final bool authenticate =
                                        await LocalAuthentication().authenticate(
                                            localizedReason:
                                                "por favor coloque la huella en el sensor");

                                    if (authenticate) {
                                      final String languageCode =
                                          context.localization.languageCode;
                                      BlocProvider.of<LoginBloc>(context).add(
                                        ProcessLoginEvent(
                                            userController.text,
                                            prefs.getString('password_key')!,
                                            languageCode),
                                      );
                                    }
                                  } catch (err) {
                                    rethrow;
                                  }
                                },
                                icon: const Icon(
                                  Icons.fingerprint,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RenewPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          '¿Olvidaste tu contraseña?',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        )),
      ),
    );
  }

  initSessionUserSave() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    fingerPrintTrue = await LocalAuthentication().canCheckBiometrics;

    final bool? userSave = prefs.getBool('userSave');
    if (userSave != null && userSave == true) {
      _userRemenber = prefs.getBool('userSave');
      userController = TextEditingController(
        text: prefs.getString('user_key'),
      );

      userNameSave = prefs.getString('user_key');
      setState(() {});
    }
  }

  bool fingerPrintTrue = false;
  String? userNameSave = '';

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }
}
