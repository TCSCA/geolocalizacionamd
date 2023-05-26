import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:go_router/go_router.dart';
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
                          decoration: InputDecoration(
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
                    const SizedBox(height: 30.0),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                  ProcessLoginEvent(userController.text,
                                      passwordController.text, languageCode));
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
                        ))
                  ],
                ),
              )),
        )),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    userController.dispose();
    passwordController.dispose();
  }
}
