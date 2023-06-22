import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';

import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/error_codes.dart' as authError;

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
  bool _visiblePasswordOff = true;

  //late final SharedPreferences prefs;
  late SharedPreferences prefs;

  ///Variables de huella
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  final auth = LocalAuthentication();

  ///Vareiables  para veirificar usuario guardado
  String userSave = '';
  bool checkUserSave = false;

  bool isNotPermanentlyDenied = false;

  @override
  void initState() {
    _validateUserSave();

    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              ///final SharedPreferences prefs = await SharedPreferences.getInstance();
              if (checkUserSave) {
                await prefs.setString('userSave', userController.text);
                await prefs.setString('password', passwordController.text);
                await prefs.setBool('checkUserSave', checkUserSave);

                if (!isNotPermanentlyDenied) {
                  if (_canCheckBiometric)
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: AppMessages().getMessageTitle(
                                context, AppConstants.statusSuccess),
                            descriptions: AppMessages().getMessage(context,
                                '¿Deseas usar la huella para inicia mas rapido?'),
                            isConfirmation: true,
                            dialogAction: () =>
                                {prefs.setBool('isNotPermanentlyDenied', true)},
                            type: AppConstants.statusSuccess,
                            isdialogCancel: false,
                            dialogCancel: () {
                              prefs.setBool('isNotPermanentlyDenied', false);
                            },
                          );
                        });
                }
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
                      isdialogCancel: false,
                      dialogCancel: () {},
                    );
                  });
            }
            if (state is LoginActiveState) {
              LoadingBuilder(context).hideOpenDialog();

              await showDialog(
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
                      isdialogCancel: false,
                      dialogCancel: () {},
                    );
                  });
            }
            if (state is ShowFirebaseKeyState) {
              LoadingBuilder(context).hideOpenDialog();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: 'Firebase Device Key',
                      descriptions: state.firebaseKey,
                      isConfirmation: true,
                      dialogAction: () {
                        Clipboard.setData(
                                ClipboardData(text: state.firebaseKey))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Key Copiado a tu portapapeles!')));
                        });
                      },
                      type: AppConstants.statusSuccess,
                      isdialogCancel: false,
                      dialogCancel: () {},
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Image.asset(
                      'assets/images/gps_doctor_image.png',
                      width: 370,
                      height: 250,
                    )),
                    Flexible(
                        child: Image.asset(
                      'assets/images/telemedicina24_logo_blanco_lineal.png',
                      width: 370,
                      height: 90,
                    )),
                    const SizedBox(height: 30.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                          key: userFieldKey,
                          controller: userController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              fillColor: const Color(0xffD84835).withAlpha(50),
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
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                          key: passwordFieldKey,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: _visiblePasswordOff,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _visiblePasswordOff = !_visiblePasswordOff;
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    _visiblePasswordOff
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white,
                                  )),
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
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: checkUserSave,
                              checkColor: const Color(0xffd84835),
                              shape: const CircleBorder(),
                              activeColor: Colors.white,
                              fillColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              onChanged: (value) async {
                                ///TODO: Falta guardar usuario
                                checkUserSave = value!;

                                if (checkUserSave == false) {
                                  if (userSave != '') {
                                    userController.clear();
                                    passwordController.clear();
                                  }

                                  await prefs.remove('userSave');
                                  await prefs.remove('checkUserSave');
                                  await prefs.remove('isNotPermanentlyDenied');
                                  await prefs.remove('password');
                                  userSave = '';
                                }

                                setState(() {});
                              }),
                          const Text(
                            'Recordar Usuario',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
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
                              onPressed: () {
                                if (!loginFormKey.currentState!.validate()) {
                                  return;
                                } else {
                                  final String languageCode =
                                      context.localization.languageCode;
                                  BlocProvider.of<LoginBloc>(context).add(
                                      ProcessLoginEvent(
                                          userController.text,
                                          passwordController.text,
                                          languageCode));
                                }
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color(0xffF96352),
                                      Color(0xffD84835)
                                    ]),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 40),
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
                            )),
                        //const SizedBox(width: 10.0),
                        /* Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  elevation: 5,
                                  side: const BorderSide(
                                      width: 2, color: Color(0xffFFFFFF)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(const ShowFirebaseKeyEvent());
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Color.fromARGB(255, 132, 130, 164),
                                      Color.fromRGBO(108, 82, 155, 1)
                                    ]),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 40),
                                  child: const Text(
                                    'Firebase',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        color: Color(0xffFFFFFF),
                                        fontFamily: 'TitlesHighlight',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )) */
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    if (_canCheckBiometric &&
                        (prefs.getBool('checkUserSave') ?? false) &&
                        isNotPermanentlyDenied)
                      _BiometricWidget(onTap: () => _authenticate()),
                    const SizedBox(height: 50.0),
                    InkWell(
                      onTap: () => launchUrl(
                        Uri.parse(
                            'https://telemedicina24ca.com/politica-de-privacidad-alojose/'),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Al pulsar iniciar, acepta los ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Términos de\nUso y Políticas de Privacidad',
                              style: TextStyle(
                                  color: Color(0xffd84835),
                                  decoration: TextDecoration.underline),
                            ),
                            TextSpan(
                              text: ' de Geolocalización',
                              style: TextStyle(
                                color: Color(0xffd84835),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
        )),
      ),
    );
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// metodo para validar si el dispositivo cumple con la autenticacion biometrica.
  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  /// Verificar los tipos autenticacion registrados
  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  ///Metodo para iniciar la autenticacion biometrica
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              cancelButton: 'Cancelar',
              goToSettingsButton: '',
              goToSettingsDescription: '',
              biometricNotRecognized:
                  'La huella dactilar es incorrecta, por favor intente nuevamente',
              biometricSuccess: '',
              biometricHint: '',
              biometricRequiredTitle: '',
              signInTitle: 'Autenticación Biométrica',
            ),
            IOSAuthMessages(
              cancelButton: 'Cerrar',
              goToSettingsButton: '',
              goToSettingsDescription: '',
              lockOut:
                  'Ha alcanzado el máximo de intentos fallidos permitidos. Introduzca la contraseña o espere unos segundos para utilizar el proceso de autenticación biométrica.',
              localizedFallbackTitle: '',
            ),
          ],
          localizedReason: "Coloque el dedo sobre el detector",
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            biometricOnly: true,
            stickyAuth: true,
          ));

      if (authenticated) {
        final String languageCode = context.localization.languageCode;

        BlocProvider.of<LoginBloc>(context).add(ProcessLoginEvent(
            userSave, prefs.getString('password')!, languageCode));
      } else {
        print('ERROR');
      }
    } on PlatformException catch (e) {
      /// _authorized = "Error - ${e.code}";
      e.code == 'LockedOut'
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusError),
                  descriptions: AppMessages().getMessage(context,
                      'Ha alcanzado el máximo de intentos fallidos permitidos. Introduzca la contraseña o espere unos segundos para utilizar el proceso de autenticación biométrica.'),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusError,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              })
          : e.code == authError.notAvailable
              ? showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                      title: AppMessages()
                          .getMessageTitle(context, AppConstants.statusError),
                      descriptions: AppMessages().getMessage(context,
                          'Este dispositivo no soporta la autenticación biométrica o no se encuentra habilitada  la funcionalidad'),
                      isConfirmation: false,
                      dialogAction: () {},
                      type: AppConstants.statusError,
                      isdialogCancel: false,
                      dialogCancel: () {},
                    );
                  })
              : e.code == 'NoHardware' || e.code == 'NotEnrolled'
                  ? showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: AppMessages().getMessageTitle(
                              context, AppConstants.statusError),
                          descriptions: AppMessages().getMessage(context,
                              'Este dispositivo no soporta la autenticación biométrica o no se encuentra habilitada  la funcionalidad'),
                          isConfirmation: false,
                          dialogAction: () {},
                          type: AppConstants.statusError,
                          isdialogCancel: false,
                          dialogCancel: () {},
                        );
                      })
                  : print('');

      // logger.e("😢 Error loger show ${e.code}");
    }
    setState(() {});
  }

  _validateUserSave() async {
    prefs = await SharedPreferences.getInstance();
    isNotPermanentlyDenied = prefs.getBool('isNotPermanentlyDenied') ?? false;
    userSave = prefs.getString('userSave') ?? '';
    checkUserSave = prefs.getBool('checkUserSave') ?? false;

    userController = TextEditingController(text: userSave);
    setState(() {});
  }

  _callShowDialog() {

  }
}

class _BiometricWidget extends StatelessWidget {
  Function() onTap;

  _BiometricWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Autenticación Biométrica',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          Icon(Icons.fingerprint, color: Color(0xffd84835), size: 35)
        ],
      ),
    );
  }
}
