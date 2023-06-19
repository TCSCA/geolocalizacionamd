import 'package:flutter/material.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';
import 'package:geolocalizacionamd/app/pages/styles/app_styles.dart';
import 'package:go_router/go_router.dart';

import '../../pages/constants/app_constants.dart';

Future<bool> dialogBuilder(
    {required BuildContext context,
    required String title,
    required description,
    required String type,
    required String buttonAccept,
    required String buttonCancel}) async {
  bool option = false;
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 10, top: 45 + 10, right: 10, bottom: 10),
              margin: const EdgeInsets.only(top: 45),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: AppStyles.colorWhite,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: _getStatusColor(type), width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: AppStyles.colorBlack,
                      offset: Offset(0, 10),
                      blurRadius: 10)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppStyles.textSizeTitle,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppStyles.fontTitlesHighlight,
                      color: _getStatusColor(type),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: AppStyles.textSizeParagraph,
                      fontFamily: AppStyles.fontTextsParagraphs,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppStyles.colorRedPrimary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        style: BorderStyle.solid,
                                        color: AppStyles.colorBeige
                                            .withOpacity(0.4))),
                              )),
                          onPressed: () {
                            option = false;
                            context.pop(); //Navigator.of(context).pop();
                          },
                          child: Text(
                            buttonCancel,
                            style: const TextStyle(
                                fontSize: AppStyles.textSizeParagraph,
                                color: AppStyles.colorWhite,
                                fontFamily: AppStyles.fontTitlesHighlight,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppStyles.colorBluePrimary),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        style: BorderStyle.solid,
                                        color: AppStyles.colorBeige
                                            .withOpacity(0.4))),
                              )),
                          onPressed: () {
                            option = true;
                            context.pop();

                          },
                          child: Text(
                            buttonAccept,
                            style: const TextStyle(
                                fontSize: AppStyles.textSizeParagraph,
                                color: AppStyles.colorWhite,
                                fontFamily: AppStyles.fontTitlesHighlight,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              child: CircleAvatar(
                backgroundColor: _getStatusColor(type),
                minRadius: 16,
                maxRadius: 36,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(45)),
                    child: Icon(
                      _getIcon(type),
                      size: 45,
                      color: AppStyles.colorWhite,
                    )),
              ),
            ),

          ],
        ),
      );

      /*AlertDialog(
        title: const Text('Basic dialog title'),
        content: const Text(
          'A dialog is a type of modal window that\n'
              'appears in front of app content to\n'
              'provide critical information, or prompt\n'
              'for a decision to be made.',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Disable'),
            onPressed: () {
              option = false;
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Enable'),
            onPressed: () {
              option = true;
              Navigator.of(context).pop();
              //return true;
            },
          ),
        ],
      );*/
    },
  );

  return option;
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