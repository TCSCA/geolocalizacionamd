import 'package:flutter/material.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/styles/app_styles.dart';

class LoadingIndicator extends StatelessWidget {
  final String menssage;
  const LoadingIndicator({super.key, required this.menssage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppStyles.colorGray,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getLoadingIndicator(),
          _getHeading(context),
          _getText(menssage)
        ],
      ),
    );
  }

  Padding _getLoadingIndicator() {
    return const Padding(
        padding: EdgeInsets.only(bottom: 16.0),
        child: SizedBox(
            width: 32.0,
            height: 32.0,
            child: CircularProgressIndicator(
              color: Color(0xff2B5178),
              strokeWidth: 3.0,
            )));
  }

  Widget _getHeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        context.appLocalization.titleHeadingLoading,
        style: AppStyles.textStyleLoading,
        textAlign: TextAlign.center,
      ),
    );
  }

  Text _getText(final String displayedText) {
    return Text(
      displayedText,
      style: AppStyles.textStyleLoading,
      textAlign: TextAlign.center,
    );
  }
}
