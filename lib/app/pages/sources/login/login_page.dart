import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/shared/method/back_button_action.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';

import 'package:local_auth_android/local_auth_android.dart';
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

  late SharedPreferences prefs;

  ///Variables de huella
  bool _canCheckBiometric = false;
  List<BiometricType> _availableBiometric = [];
  final auth = LocalAuthentication();

  ///Vareiables  para veirificar usuario guardado
  String userSave = '';
  bool checkUserSave = false;

  String denyFingerprint = '';
  bool isUsedFingerprint = false;
  bool authenticated = false;

  @override
  void initState() {
    _validateUserSave();

    _checkBiometric();
    _getAvailableBiometric();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => backButtonActions(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xff2B5178),
              Color(0xff273456),
            ],
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
                  if (checkUserSave) {
                    await prefs.setString('userSave', userController.text);

                    await prefs.setBool('checkUserSave', checkUserSave);

                    if (!isUsedFingerprint) {
                      await prefs.setString(
                          'password', passwordController.text);
                    }

                    if (denyFingerprint != 'N' && denyFingerprint != 'Y') {
                      if (_canCheckBiometric) {
                        if (context.mounted) {
                          await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return CustomDialogBox(
                                  title: AppMessages().getMessageTitle(
                                      context, AppConstants.statusSuccess),
                                  descriptions: AppMessages().getMessage(
                                      context,
                                      context.appLocalization.appMsg229),
                                  isConfirmation: true,
                                  dialogAction: () =>
                                      prefs.setString('denyFingerprint', 'Y'),
                                  type: AppConstants.statusSuccess,
                                  isdialogCancel: true,
                                  dialogCancel: () =>
                                      prefs.setString('denyFingerprint', 'N'),
                                );
                              });
                        }
                      }
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
                          title: AppMessages().getMessageTitle(
                              context, AppConstants.statusError),
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
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: AppMessages().getMessageTitle(
                              context, AppConstants.statusWarning),
                          descriptions:
                              AppMessages().getMessage(context, state.message),
                          isConfirmation: true,
                          dialogAction: () =>
                              BlocProvider.of<LoginBloc>(context).add(
                                  ProcessResetLoginEvent(
                                      authenticated
                                          ? userSave
                                          : userController.text,
                                      authenticated
                                          ? prefs.getString('password')!
                                          : passwordController.text,
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
                                      content: Text(
                                          'Key Copiado a tu portapapeles!')));
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
                        width: 250,
                        height: 200,
                      )),
                      Flexible(
                          child: Image.asset(
                        'assets/images/telemedicina24_logo_blanco_lineal.png',
                        width: 370,
                        height: 80,
                      )),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                            key: userFieldKey,
                            controller: userController,
                            keyboardType: TextInputType.text,
                            maxLength: 15,
                            decoration: InputDecoration(
                                errorMaxLines: 2,
                                fillColor:
                                    const Color(0xffD84835).withAlpha(50),
                                counterStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'TitlesHighlight'),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (fieldValue) {
                              if (fieldValue!.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (fieldValue.length < 6) {
                                return 'Longitud del dato menor a la minima requerida';
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
                            maxLength: 12,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _visiblePasswordOff =
                                          !_visiblePasswordOff;
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      _visiblePasswordOff
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    )),
                                errorMaxLines: 2,
                                fillColor:
                                    const Color(0xffD84835).withAlpha(50),
                                counterStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontFamily: 'TitlesHighlight'),
                                hintText: 'Contraseña',
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (fieldValue) {
                              if (fieldValue!.isEmpty) {
                                return 'Campo requerido';
                              }
                              if (fieldValue.length < 4) {
                                return 'Longitud del dato menor a la minima requerida';
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
                                    await prefs.remove('denyFingerprint');
                                    await prefs.remove('password');
                                    userSave = '';
                                    denyFingerprint = '';
                                  }

                                  setState(() {});
                                }),
                            const Text(
                              'Recordar Usuario',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
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
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      if (_canCheckBiometric &&
                          (prefs.getBool('checkUserSave') ?? false) &&
                          denyFingerprint == 'Y')
                        _BiometricWidget(onTap: () => _authenticate(context)),
                      const SizedBox(height: 50.0),
                      /*Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        //width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RenewPasswordPage()));
                          },
                          child: Text(
                            context.appLocalization.forgotPassword,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),*/
                      InkWell(
                        onTap: () => launchUrl(
                          Uri.parse(
                              'https://telemedicina24ca.com/politica-de-privacidad-alojose/'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Al pulsar ingresar, acepta los ',
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
                                text: ' de Telemedicina24',
                                style: TextStyle(
                                  color: Color(0xffd84835),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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

    /* bool? autoStart = await isAutoStartAvailable;

    if(autoStart != null && autoStart) {

      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: AppMessages().getMessageTitle(
                  context, AppConstants.statusSuccess),
              descriptions: AppMessages().getMessage(context,
                  'para poder hacer uso de todos nuestro servicios, debera'),
              isConfirmation: true,
              dialogAction: () {},
              type: AppConstants.statusSuccess,
              isdialogCancel: false,
              dialogCancel: () {},
            );
          });

      await getAutoStartPermission();
    }*/

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
  Future<void> _authenticate(BuildContext context) async {
    try {
      authenticated = await auth.authenticate(
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
              cancelButton: 'Cancelar',
              goToSettingsButton: '',
              goToSettingsDescription: '',
              biometricNotRecognized:
                  context.appLocalization.invalidFingerprint,
              biometricSuccess: '',
              biometricHint: '',
              biometricRequiredTitle: '',
              signInTitle: context.appLocalization.biometricAuthentication,
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
        isUsedFingerprint = true;
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
                  descriptions: AppMessages().getMessage(
                      context, context.appLocalization.limitBiometricAttempts),
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
                          context.appLocalization.biometricNotSupported),
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
                              context.appLocalization.biometricNotSupported),
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
    denyFingerprint = prefs.getString('denyFingerprint') ?? '';
    userSave = prefs.getString('userSave') ?? '';
    checkUserSave = prefs.getBool('checkUserSave') ?? false;

    userController = TextEditingController(text: userSave);
    setState(() {});
  }

  _callShowDialog() {}
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.appLocalization.biometricAuthentication,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          const Icon(Icons.fingerprint, color: Color(0xffd84835), size: 35)
        ],
      ),
    );
  }
}
