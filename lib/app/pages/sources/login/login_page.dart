import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocalizacionamd/app/core/controllers/secure_storage_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/pages/messages/app_messages.dart';
import '/app/pages/routes/geoamd_route.dart';
import '/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import '/app/shared/dialog/custom_dialog_box.dart';
import '/app/shared/loading/loading_builder.dart';

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
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _visiblePasswordOff = true;
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
          listener: (context, state) {
            if (state is LoginShowLoadingState) {
              LoadingBuilder(context).showLoadingIndicator(
                  context.appLocalization.titleLoginLoading);
            }
            if (state is LoginSuccessState) {
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
                              fillColor: const Color(0xffD84835).withAlpha(50),
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
                                  fontSize: 15.0,
                                  fontFamily: 'TextsParagraphs')),
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 19.0,
                              fontFamily: 'TitlesHighlight'),
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
                                  fontSize: 15.0,
                                  fontFamily: 'TextsParagraphs')),
                          style: const TextStyle(
                              color: Color(0xffFFFFFF),
                              fontSize: 19.0,
                              fontFamily: 'TitlesHighlight'),
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
                    /* const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                              value: false,
                              checkColor: const Color(0xffd84835),
                              shape: const CircleBorder(),
                              activeColor: Colors.white,
                              fillColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              onChanged: (value) {}),
                          const Text(
                            'Recordar Usuario',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ), */
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
                    /* const SizedBox(height: 30.0),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Autenticación Biométrica',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          Icon(Icons.fingerprint,
                              color: Color(0xffd84835), size: 35)
                        ],
                      ),
                    ), */
                    const SizedBox(height: 50.0),
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
}
