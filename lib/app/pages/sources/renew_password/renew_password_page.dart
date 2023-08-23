import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/renew_password/bloc/renew_password_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/renew_password_controller.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../../shared/loading/loading_builder.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
import '../../routes/geoamd_route.dart';
import '../../styles/app_styles.dart';
import '../navigation/bloc/navigation_bloc.dart';

class RenewPasswordPage extends StatelessWidget {
  RenewPasswordPage({Key? key}) : super(key: key);

  final TextEditingController _usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RenewPasswordBloc(renewPasswordController: RenewPasswordController()),
      child: _RenewPasswordView(usernameCtrl: _usernameCtrl),
    );
  }
}

class _RenewPasswordView extends StatelessWidget {
  _RenewPasswordView({
    super.key,
    required TextEditingController usernameCtrl,
  }) : _usernameCtrl = usernameCtrl;

  final TextEditingController _usernameCtrl;
  final GlobalKey<FormState> renewPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> userFieldKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          //  color: const Color(0xff2B5178),
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: _BackgroundStyle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: BlocConsumer<RenewPasswordBloc, RenewPasswordState>(
                listener: (context, state) async {
                  if (state is IsLoadingState) {
                    LoadingBuilder(context)
                        .showLoadingIndicator('Procesando solicitud');
                  } else if (state is SuccessRenewPassword) {
                    LoadingBuilder(context).hideOpenDialog();
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: AppMessages().getMessageTitle(
                                context, AppConstants.statusSuccess),
                            descriptions: AppMessages().getMessage(context,
                                'El enlace ha sido enviado con éxito. A partir de este momento dispone de 30 minutos, revise su correo electrónico y siga los pasos'),
                            isConfirmation: false,
                            dialogAction: () {},
                            type: AppConstants.statusSuccess,
                            dialogCancel: () {},
                            isdialogCancel: false,
                          );
                        });
                    if (context.mounted) {
                      context.go(GeoAmdRoutes.login, extra: NavigationBloc());
                    }
                  } else if (state is ErrorRenewPasswordState) {
                    LoadingBuilder(context).hideOpenDialog();
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: AppMessages().getMessageTitle(
                                context, AppConstants.statusWarning),
                            descriptions: AppMessages()
                                .getMessage(context, state.messageError),
                            isConfirmation: false,
                            dialogAction: () {},
                            type: AppConstants.statusError,
                            dialogCancel: () {},
                            isdialogCancel: false,
                          );
                        });
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: renewPasswordFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Image.asset(
                            'assets/images/telemedicina24_logo_blanco_lineal.png',
                            width: 320,
                          ),
                        ),
                        Container(
                          //margin: EdgeInsets.all(30),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40)),
                              boxShadow: [
                                BoxShadow(color: Colors.black, blurRadius: 5),
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 30, bottom: 10),
                                child: const Text(
                                  "Recuperar Contraseña",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Center(
                                  child: TextFormField(
                                    maxLength: 15,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      final RegExp regExp = RegExp(
                                          r'^[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*$');
                                      if (!regExp.hasMatch(value!) &&
                                          value != '') {
                                        return context
                                            .appLocalization.invalidData;
                                      } else {
                                        if (value.length > 15) {
                                          return 'maxLength';
                                        } else if (value.length < 6 &&
                                            value != '') {
                                          return context.appLocalization
                                              .invalidLengthField;
                                        } else if (value == '') {
                                          return context
                                              .appLocalization.fieldRequired;
                                        }
                                      }
                                      return null;
                                    },
                                    key: userFieldKey,
                                    controller: _usernameCtrl,
                                    decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 5),
                                        labelStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        labelText: 'Usuario (*)',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        //hintText: placeHolder,
                                        hintStyle: TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                        icon: Icon(Icons.person),
                                        hintText: "Ingrese nombre de usuario"),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            elevation: 5,
                                            side: const BorderSide(
                                                width: 2,
                                                color: Color(0xffFFFFFF)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () {
                                          context.go(GeoAmdRoutes.login,
                                              extra: NavigationBloc());
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xffF96352),
                                                    Color(0xffD84835)
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: Text(
                                              context.appLocalization
                                                  .nameButtonCancel,
                                              textAlign: TextAlign.center,
                                              style: AppStyles.textStyleButton,
                                            ),
                                          ),
                                        ),
                                      )),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            elevation: 5,
                                            side: const BorderSide(
                                                width: 2,
                                                color: Color(0xffFFFFFF)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30))),
                                        onPressed: () {
                                          if (renewPasswordFormKey.currentState!
                                              .validate()) {
                                            context.read<RenewPasswordBloc>().add(
                                                SendEmailToRenewPasswordEvent(
                                                    username:
                                                        _usernameCtrl.text));
                                          } else {
                                            return;
                                          }
                                        },
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xff2B5178),
                                                    Color(0xff273456)
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 20),
                                            child: Text(
                                              context.appLocalization
                                                  .nameButtonAccept,
                                              textAlign: TextAlign.center,
                                              style: AppStyles.textStyleButton,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )),
    );
  }
}

class _BackgroundStyle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    final paint = Paint();

    paint.color = const Color(0xff2B5178);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 5;

    final path = Path();

    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.45, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw true;
  }
}
