import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/shared/digital_signature_bloc/digital_signature_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/dialog/custom_dialog_box.dart';
import '../../../../shared/image_build/bloc/image_profile_bloc.dart';
import '../../../../shared/loading/loading_builder.dart';
import '../../../../shared/method/back_button_action.dart';
import '../../../constants/app_constants.dart';
import '../../../messages/app_messages.dart';
import '../../../styles/app_styles.dart';

class DigitalSignatureWidget extends StatelessWidget {
  Uint8List? signatureBuild = null;

  DigitalSignatureWidget({super.key, this.signatureBuild});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<DigitalSignatureBloc>(context)
        .add(ConsultDigitalSignatureeEvent());
    return BlocConsumer<DigitalSignatureBloc, DigitalSignatureState>(
      listener: (context, state) {
        if (state is LoadingDigitalSignatureState) {
          LoadingBuilder(context)
              .showLoadingIndicator('Cargando firma del doctor');
        } else if (state is DigitalSignatureSuccess) {
          LoadingBuilder(context).hideOpenDialog();
          signatureBuild = state.doctorSignatureBuild;
        } else if (state is DigitalSignatureErrorState) {
          GoRouter.of(context).pop();
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
        if (state is DigitalSignatureSuccess) {
          return WillPopScope(
            onWillPop: () => backButtonActions(),
            child: Dialog(
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
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                elevation: 5,
                                side: const BorderSide(
                                    width: 2, color: Color(0xffFFFFFF)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              GoRouter.of(context).pop();
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
                                    vertical: 15, horizontal: 20),
                                child: Text(
                                  context.appLocalization.nameButtonReturn,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.textStyleButton,
                                ),
                              ),
                            ),
                          )),
                    ],
                  )),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
