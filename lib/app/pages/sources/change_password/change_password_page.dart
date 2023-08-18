import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/controllers/change_password_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/constants/app_constants.dart';
import 'package:geolocalizacionamd/app/pages/messages/app_messages.dart';
import 'package:geolocalizacionamd/app/pages/routes/geoamd_route.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/login_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/navigation/bloc/navigation_bloc.dart';
import 'package:geolocalizacionamd/app/shared/dialog/custom_dialog_box.dart';
import 'package:geolocalizacionamd/app/shared/loading/loading_builder.dart';

import 'package:geolocalizacionamd/app/validations/password_validation.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/image_profile_controller.dart';
import '../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../login/bloc/login_bloc.dart';
import '../profile/bloc/profile_bloc.dart';
import 'change_password_bloc.dart';

/*import '../../../../shared/dialog/custom_dialog_box.dart';
import '../../../../shared/loading/loading_builder.dart';
import '../../../constants/app_constants.dart';
import '../../../messages/app_messages.dart';
import '../../../routes/geoamd_route.dart';
import '../../navigation/bloc/navigation_bloc.dart';*/
//

class ChangedPasswordPage extends StatelessWidget {
  ChangedPasswordPage({Key? key, required this.username}) : super(key: key);

  String username;

  @override
  Widget build(BuildContext context) {
    /// Input Controller
    TextEditingController passwordCtrl = TextEditingController();
    TextEditingController passwordConfirmCtrl = TextEditingController();

    ///Key Controller
    final formKey = GlobalKey<FormState>();
    final GlobalKey<FormFieldState> passwordKey = GlobalKey<FormFieldState>();
    final GlobalKey<FormFieldState> passwordConfirmKey =
        GlobalKey<FormFieldState>();

    return Scaffold(
      body: BlocProvider(
        create: (context) => ChangePasswordBloc(
            changePasswordController: ChangePasswordController()),
        child: _ChangePasswordView(
            formKey: formKey,
            passwordKey: passwordKey,
            passwordCtrl: passwordCtrl,
            passwordConfirmKey: passwordConfirmKey,
            passwordConfirmCtrl: passwordConfirmCtrl,
            username: username),
      ),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  _ChangePasswordView({
    super.key,
    required this.formKey,
    required this.passwordKey,
    required this.passwordCtrl,
    required this.passwordConfirmKey,
    required this.passwordConfirmCtrl,
    required this.username,
  });

  final GlobalKey<FormState> formKey;
  final GlobalKey<FormFieldState> passwordKey;
  final TextEditingController passwordCtrl;
  final GlobalKey<FormFieldState> passwordConfirmKey;
  final TextEditingController passwordConfirmCtrl;
  final String username;

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  bool visibilityPassword = false;

  bool visibilityPasswordConfirm = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) async {
          // TODO: implement listener
          if (state is ChangePasswordLoadingState) {
            LoadingBuilder(context).showLoadingIndicator(
                context.appLocalization.changePasswordAction);
          } else if (state is ChangePasswordSuccessState) {
            LoadingBuilder(context).hideOpenDialog();
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusSuccess),
                    descriptions: AppMessages().getMessage(
                        context, state.changePasswordModel.data!.message!),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusSuccess,
                    dialogCancel: () {},
                    isdialogCancel: false,
                  );
                });
            BlocProvider.of<LoginBloc>(context)
                .add(ProcessLoginEvent(widget.username, widget.passwordCtrl.text, context.localization.languageCode));
            // context.go(GeoAmdRoutes.home, extra: NavigationBloc());
          } else if (state is ChangePasswordErrorState) {
            LoadingBuilder(context).hideOpenDialog();
            await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: AppMessages()
                        .getMessageTitle(context, AppConstants.statusWarning),
                    descriptions:
                        AppMessages().getMessage(context, state.messageError),
                    isConfirmation: false,
                    dialogAction: () {},
                    type: AppConstants.statusError,
                    dialogCancel: () {},
                    isdialogCancel: false,
                  );
                });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            // context.go(GeoAmdRoutes.login, extra: NavigationBloc());
          }
        }),
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginShowLoadingState) {
              LoadingBuilder(context).showLoadingIndicator(
                  context.appLocalization.titleLoginLoading);
            }
            if (state is LoginSuccessState) {
              Uint8List? image =
                  await ImageProfileController().doConsultDataImageProfile();
              BlocProvider.of<ImageProfileBloc>(context)
                  .add(ImageProfileInitialEvent(imageBuild: image));
              BlocProvider.of<ProfileBloc>(context)
                  .add(GetProfileInitialEvent());

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

              context.go(GeoAmdRoutes.login, extra: NavigationBloc());
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
                              widget.username,
                              widget.passwordCtrl.text,
                              context.localization.languageCode)),
                      type: AppConstants.statusWarning,
                      isdialogCancel: false,
                      dialogCancel: () {},
                    );
                  });
            }
          },

        )
      ],
      child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Color(0xff2B5178), Color(0xff273456)],
              begin: Alignment(0.0, 0.0),
              end: Alignment(0.25, 0.75),
            )),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: double.infinity,
            child: Form(
              key: widget.formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        height: 150,
                        child: Image.asset(
                          'assets/images/telemedicina24_logo_blanco_lineal.png',
                          width: 370,
                          height: 90,
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                        child: Text(
                          'Crear nueva contraseña',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'TitlesHighlight',
                              color: Colors.white),
                        ),
                      ),
                      TextFormField(
                        key: widget.passwordKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return PasswordValidation().passwordValidator(value!);
                        },
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                            fontFamily: 'TitlesHighlight'),
                        obscureText: !visibilityPassword,
                        obscuringCharacter: '*',
                        controller: widget.passwordCtrl,
                        decoration: InputDecoration(
                            prefix: const SizedBox(
                              width: 15,
                            ),
                            hintStyle: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 19.0,
                                fontFamily: 'TitlesHighlight'),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffFFFFFF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffFFFFFF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE3D3B2),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            errorStyle: const TextStyle(
                                color: Color(0xffD84835),
                                fontSize: 14.0,
                                fontFamily: 'TextsParagraphs'),
                            hintText: 'Contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(
                                visibilityPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                visibilityPassword = !visibilityPassword;
                                setState(() {});
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: widget.passwordConfirmKey,
                        validator: (value) {
                          return PasswordValidation().confirmPasswordValidator(
                              value!, widget.passwordCtrl.text);
                        },
                        obscuringCharacter: '*',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19.0,
                            fontFamily: 'TitlesHighlight'),
                        obscureText: !visibilityPasswordConfirm,
                        controller: widget.passwordConfirmCtrl,
                        decoration: InputDecoration(
                            prefix: const SizedBox(width: 15),
                            hintStyle: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontSize: 19.0,
                                fontFamily: 'TitlesHighlight'),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffFFFFFF),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffFFFFFF),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffE3D3B2),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            errorStyle: const TextStyle(
                                color: Color(0xffD84835),
                                fontSize: 14.0,
                                fontFamily: 'TextsParagraphs'),
                            hintText: 'Confirmar contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(
                                visibilityPasswordConfirm
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                visibilityPasswordConfirm =
                                    !visibilityPasswordConfirm;
                                setState(() {});
                              },
                            )),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
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
                              validateAndSave(context);
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
                                  'Cambiar Contraseña',
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
                      /*Container(
                    // height: 250,
                    child: MaterialButton(
                      minWidth: 250,
                      color: Colors.white,
                      onPressed: () {
                        validateAndSave(context);
                      },
                      child: const Text('Cambiar'),
                    ),
                  )*/
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  void validateAndSave(BuildContext context) {
    final FormState? form = widget.formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');

      context.read<ChangePasswordBloc>().add(SendToServiceChangePassword(
          password: widget.passwordCtrl.text, username: widget.username));
    } else {
      print('Form is invalid');
    }
  }
}
