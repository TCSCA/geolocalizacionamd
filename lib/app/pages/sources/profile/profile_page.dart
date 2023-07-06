import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/method/back_button_action.dart';
import '/app/pages/widgets/common_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => backButtonActions(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppCommonWidgets.generateAppBar(
              context: context, appBarHeight: 140.0),
          body: MultiBlocListener(
            listeners: [
              //NavigationBloc y LogoutBloc comunes en todas las paginas.
              AppCommonWidgets.listenerNavigationBloc(),
              AppCommonWidgets.listenerLogoutBloc()
            ],
            child: Container(
              padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
              child: GestureDetector(
                onTap: () {},
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    image:
                                        AssetImage('assets/images/doctor_1.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(width: 4, color: Colors.white),
                                    color: Colors.blue),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    buildTextField(
                      labelText: 'Nombre Completo',
                      placeHolder: 'Argenis Méndez',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Documento de Identidad',
                      placeHolder: '16547852',
                      isReadOnly: true,
                    ),
                    buildTextField(
                      labelText: 'Correo Electrónico',
                      placeHolder: 'medicoamd@telemedicina24ca.com',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Género',
                      placeHolder: 'Hombre',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Fecha de Nacimiento',
                      placeHolder: '1996-06-06',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Numero de Teléfono',
                      placeHolder: '04141234567',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Otro teléfono',
                      placeHolder: '04141234567',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'País',
                      placeHolder: 'Venezuela',
                      isReadOnly: true,
                    ),
                    buildTextField(
                      labelText: 'Estado',
                      placeHolder: 'Distrito Capital',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Ciudad',
                      placeHolder: 'Caracas',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'Dirección',
                      placeHolder:
                          'Los frailes de Catia - Segunda Calle - Callejón los Cedros. Entrada Macayapa',
                      isReadOnly: false,
                    ),
                    buildTextField(
                      labelText: 'M.P.P.S',
                      placeHolder: '0000000000',
                      isReadOnly: true,
                    ),
                    buildTextField(
                      labelText: 'C.M',
                      placeHolder: '0000000000',
                      isReadOnly: true,
                    ),
                    buildTextField(
                      labelText: 'Especialidad',
                      placeHolder: 'Doctor AMD',
                      isReadOnly: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      {required String labelText,
      required String placeHolder,
      required bool isReadOnly}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 20, left: 20),
      child: TextField(
        readOnly: isReadOnly,
        minLines: 1,
        maxLines: 5,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            labelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeHolder,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
