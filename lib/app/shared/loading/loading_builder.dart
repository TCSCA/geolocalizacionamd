import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '/app/pages/styles/app_styles.dart';
import '/app/shared/loading/loading_indicator.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';

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
              title: Text(
                context.appLocalization.titleHeadingLoading,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff2B5178),
                    ),
                textAlign: TextAlign.center,
              ),
              titlePadding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(
                  color: AppStyles.colorBluePrimary,
                  style: BorderStyle.solid,
                  width: 2.0,
                ),
              ),
              backgroundColor: AppStyles.colorWhite,
              content: LoadingIndicator(menssage: description),
              contentPadding: const EdgeInsets.all(16),
            ),
          );
        });
  }

  void hideOpenDialog() {
    context.pop();
  }
}
