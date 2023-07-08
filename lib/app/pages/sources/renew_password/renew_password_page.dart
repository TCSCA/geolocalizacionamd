import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/sources/login/login_page.dart';
import 'package:geolocalizacionamd/app/pages/sources/renew_password/bloc/renew_password_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/controllers/renew_password_controller.dart';
import '../../../shared/dialog/custom_dialog_box.dart';
import '../../constants/app_constants.dart';
import '../../messages/app_messages.dart';
import '../../routes/geoamd_route.dart';
import '../navigation/bloc/navigation_bloc.dart';

class RenewPasswordPage extends StatelessWidget {
  RenewPasswordPage({Key? key}) : super(key: key);

  TextEditingController _usernameCtrl = TextEditingController();

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
  const _RenewPasswordView({
    super.key,
    required TextEditingController usernameCtrl,
  }) : _usernameCtrl = usernameCtrl;

  final TextEditingController _usernameCtrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: _BackgroundStyle(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: BlocConsumer<RenewPasswordBloc, RenewPasswordState>(
                listener: (context, state) async {
                  if (state is IsLoadingState) {
                  } else if (state is SuccessRenewPassword) {
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: AppMessages().getMessageTitle(
                                context, AppConstants.statusWarning),
                            descriptions: AppMessages().getMessage(
                                context, state.renewPasswordModel.data),
                            isConfirmation: false,
                            dialogAction: () {},
                            type: AppConstants.statusError,
                            dialogCancel: () {},
                            isdialogCancel: false,
                          );
                        });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else if (state is ErrorRenewPasswordState) {
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

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 100,
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                          Container(
                            height: 200,
                            child: Image.asset(
                              'assets/images/telemedicina24_logo_blanco_lineal.png',
                              width: 300,
                              height: 90,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        child: const Text(
                          "Recuperar Contraseña",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            controller: _usernameCtrl,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.person), hintText: "Usuaro"),
                          ),
                        ),
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
                              context.read<RenewPasswordBloc>().add(
                                  SendEmailToRenewPasswordEvent(
                                      username: _usernameCtrl.text));
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
                                  'Renovar',
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

    paint.color = Color(0xff2B5178);
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
