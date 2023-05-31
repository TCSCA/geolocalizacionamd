import 'package:flutter/material.dart';

class RenewPasswordPage extends StatelessWidget {
  const RenewPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: _BackgroundStyle(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    child: Image.asset(
                      'assets/images/telemedicina24_logo_blanco_lineal.png',
                      width: 370,
                      height: 90,
                    ),
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
                  const Expanded(
                    child: Center(
                      child: TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.email), hintText: "Correo"),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.orange),
                    child: MaterialButton(
                      minWidth: double.infinity * 0.1,
                      onPressed: () {},
                      child: Text(
                        'Renovar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
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

    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.5, size.width, size.height * 0.7);
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
