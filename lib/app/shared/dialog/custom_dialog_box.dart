import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/pages/constants/app_constants.dart';
import '/app/extensions/localization_ext.dart';

typedef DialogAction = Function();
typedef DialogCancel = Function();

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, type;
  final bool isConfirmation, isdialogCancel;
  final DialogAction dialogAction;
  final DialogCancel dialogCancel;

  const CustomDialogBox(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.isConfirmation,
      required this.dialogAction,
      required this.type,
      required this.dialogCancel,
      required this.isdialogCancel})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 10, top: 40, right: 10, bottom: 10),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: AppStyles.colorWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _getStatusColor(widget.type), width: 2),
              boxShadow: const [
                BoxShadow(
                    color: AppStyles.colorBlack,
                    offset: Offset(0, 10),
                    blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(widget.type)),
                  textAlign: TextAlign.justify
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.isConfirmation) ...[
                    TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 18)),
                            backgroundColor: MaterialStateProperty.all(
                                AppStyles.colorRedPrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: AppStyles.colorBeige
                                          .withOpacity(0.4))),
                            )),
                        onPressed: () {
                          if (widget.isdialogCancel) {
                            context.pop();
                            widget.dialogCancel.call();
                          } else {
                            context.pop();
                          }
                        },
                        child: Text(
                          context.appLocalization.nameButtonCancel,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20)),
                            backgroundColor: MaterialStateProperty.all(
                                AppStyles.colorBluePrimary),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: AppStyles.colorBeige
                                          .withOpacity(0.4))),
                            )),
                        onPressed: () {
                          context.pop();
                          widget.dialogAction.call();
                        },
                        child: Text(
                          context.appLocalization.nameButtonAccept,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ))
                  ] else ...[
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all(
                            AppStyles.colorBluePrimary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                  style: BorderStyle.solid,
                                  color:
                                      AppStyles.colorBeige.withOpacity(0.4))),
                        ),
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(
                        context.appLocalization.nameButtonClose,
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    )
                  ]
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: _getStatusColor(widget.type),
            minRadius: 16,
            maxRadius: 36,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Icon(
                  _getIcon(widget.type),
                  size: 45,
                  color: AppStyles.colorWhite,
                )),
          ),
        ),
      ],
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case AppConstants.statusError:
      return AppStyles.colorError;
    case AppConstants.statusWarning:
      return AppStyles.colorWarning;
    case AppConstants.statusSuccess:
      return AppStyles.colorSuccess;
    default:
      return AppStyles.colorGray;
  }
}

IconData? _getIcon(String nombreIcono) {
  return AppConstants.iconsMenu[nombreIcono];
}
