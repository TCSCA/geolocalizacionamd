import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/core/controllers/renew_password_controller.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';

import 'bloc/renew_password_bloc.dart';

class RenewPasswordPage extends StatelessWidget {
  const RenewPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RenewPasswordBloc(renewPasswordController: RenewPasswordController()),
      child: _RenewPaswordView(),
    );
  }
}

class _RenewPaswordView extends StatelessWidget {
  TextEditingController _emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: _BackgroundStyle(),
            child: BlocConsumer<RenewPasswordBloc, RenewPasswordState>(
              listener: (context, state) {
                if (state is IsLoadingState) {
                  print('Esta Cargando la data');
                } else if (state is SuccessRenewPassword) {
                } else if (state is ErrorRenewPasswordState) {}
              },
              builder: (context, state) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
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
                        child: Text(
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
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailCtrl,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.email), hintText: "Correo"),
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
                                    email: _emailCtrl.text));
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
                        ),
                      ),
                    ],
                  ),
                );
              },
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
