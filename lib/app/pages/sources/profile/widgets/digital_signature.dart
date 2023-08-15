import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/dialog/custom_dialog_box.dart';
import '../../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../../../../shared/loading/loading_builder.dart';
import '../../../constants/app_constants.dart';
import '../../../messages/app_messages.dart';

class DigitalSignatureWidget extends StatelessWidget {
  Uint8List? signatureBuild = null;

  DigitalSignatureWidget({super.key, this.signatureBuild});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ImageProfileBloc>(context)
        .add(ConsultDigitalSignatureEvent());
    return BlocConsumer<ImageProfileBloc, ImageProfileState>(
      listener: (context, state) {
        if (state is LoadingImageState) {
          LoadingBuilder(context)
              .showLoadingIndicator('Cargando firma del doctor');
        } else if (state is ImageChangeSuccessState) {
          LoadingBuilder(context).hideOpenDialog();
          signatureBuild = state.doctorSignatureBuild;
        } else if (state is ImageErrorState) {
          LoadingBuilder(context).hideOpenDialog();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomDialogBox(
                  title: AppMessages()
                      .getMessageTitle(context, AppConstants.statusError),
                  descriptions:
                      AppMessages().getMessage(context, state.messageError),
                  isConfirmation: false,
                  dialogAction: () {},
                  type: AppConstants.statusError,
                  isdialogCancel: false,
                  dialogCancel: () {},
                );
              });
        }
      },
      builder: (context, state) {
        if (state is ImageChangeSuccessState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 200,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (signatureBuild != null)
                      Image.memory(
                        signatureBuild!,
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                    MaterialButton(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.blueGrey)],
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: const Text(
                              'Cerrar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        onPressed: () {
                          Navigator.pop(context);
                          //context.pop();
                        })
                  ],
                )),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
