import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/shared/loading/loading_indicator.dart';

class LoadingBuilder {
  LoadingBuilder(this.context);
  final BuildContext context;

  void showLoadingIndicator(String description) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: AppStyles.colorBluePrimary.withOpacity(0.2),
        useSafeArea: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  side: BorderSide(
                      color: AppStyles.colorBluePrimary,
                      style: BorderStyle.solid,
                      width: 4.0)),
              backgroundColor: AppStyles.colorGray,
              content: LoadingIndicator(menssage: description),
            ),
          );
        });
  }

  void hideOpenDialog() {
    context.pop();
  }
}
