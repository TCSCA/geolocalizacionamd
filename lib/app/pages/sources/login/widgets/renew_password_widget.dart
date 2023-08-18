import 'package:flutter/material.dart';

import '../../../../shared/method/back_button_action.dart';
import '../../../../validations/password_validation.dart';

class ChangePasswordWidget extends StatefulWidget {
   ChangePasswordWidget({super.key});

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  TextEditingController passwordCtrl = TextEditingController();

  TextEditingController passwordConfirmCtrl = TextEditingController();

   final formKey = GlobalKey<FormState>();

   final GlobalKey<FormFieldState> passwordKey = GlobalKey<FormFieldState>();

   final GlobalKey<FormFieldState> passwordConfirmKey =
   GlobalKey<FormFieldState>();

  bool visibilityPassword = false;

  bool visibilityPasswordConfirm = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity * 1,
            height: 400,
            padding: const EdgeInsets.all(30),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                    child: Text(
                      'Crear nueva contraseña',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TitlesHighlight',
                          color: Colors.black),
                    ),
                  ),
                  TextFormField(
                    key: passwordKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return PasswordValidation().passwordValidator(value!);
                    },
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 19.0,
                        fontFamily: 'TitlesHighlight'),
                    obscureText: !visibilityPassword,
                    obscuringCharacter: '*',
                    controller: passwordCtrl,
                   /* decoration: InputDecoration(
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
                        )),*/
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: passwordConfirmKey,
                    validator: (value) {
                      return PasswordValidation()
                          .confirmPasswordValidator(value!, passwordCtrl.text);
                    },
                    obscuringCharacter: '*',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19.0,
                        fontFamily: 'TitlesHighlight'),
                    obscureText: !visibilityPasswordConfirm,
                    controller: passwordConfirmCtrl,
                   /* decoration: InputDecoration(
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
                            visibilityPasswordConfirm = !visibilityPasswordConfirm;
                            setState(() {});
                          },
                        )),*/
                  ),
                  const SizedBox(
                    height: 100,
                  ),

                /*  Container(
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
                      ))*/
                ],
              ),
            ),
          ),
        ),
        onWillPop: () => backButtonActions());
  }

  void validateAndSave(BuildContext context) {
    final FormState? form = formKey.currentState;
    if (form!.validate()) {
      print('Form is valid');

     /* context.read<ChangePasswordBloc>().add(SendToServiceChangePassword(
          password: widget.passwordCtrl.text, username: widget.username));*/
    } else {
      print('Form is invalid');
    }
  }
}
