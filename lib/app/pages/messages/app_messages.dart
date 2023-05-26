import 'package:flutter/material.dart';
import '/app/extensions/localization_ext.dart';
import '/app/pages/constants/app_constants.dart';

class AppMessages {
  String getMessageTitle(BuildContext context, String status) {
    if (status.trim() == AppConstants.statusWarning) {
      return context.appLocalization.titleWarning;
    }
    if (status.trim() == AppConstants.statusError) {
      return context.appLocalization.titleError;
    }
    if (status.trim() == AppConstants.statusSuccess) {
      return context.appLocalization.titleSuccess;
    }
    return '';
  }

  String getMessage(BuildContext context, String code) {
    if (code.trim() == 'MSG-001') {
      return context.appLocalization.apiMsg001;
    }
    if (code.trim() == 'MSG-016') {
      return context.appLocalization.apiMsg016;
    }
    if (code.trim() == 'MSG-057') {
      return context.appLocalization.apiMsg057;
    }
    return code;
  }
}
