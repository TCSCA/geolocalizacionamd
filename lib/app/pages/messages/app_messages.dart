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
    if (code.trim() == 'MSG-033') {
      return context.appLocalization.apiMsg033;
    }
    if (code.trim() == 'MSG-057') {
      return context.appLocalization.apiMsg057;
    }
    if (code.trim() == 'MSG-125') {
      return context.appLocalization.apiMsg125;
    }
    if (code.trim() == 'MSG-135') {
      return context.appLocalization.apiMsg135;
    }
    if (code.trim() == 'MSG-225') {
      return context.appLocalization.apiMsg225;
    }
    if (code.trim() == 'MSG-230') {
      return context.appLocalization.apiMsg230;
    }
    if (code.trim() == 'MSG-232') {
      return context.appLocalization.apiMsg232;
    }
    if (code.trim() == 'MSGAPP-001') {
      return context.appLocalization.appMsg001;
    }
    if (code.trim() == 'MSGAPP-002') {
      return context.appLocalization.appMsg002;
    }
    if (code.trim() == 'MSGAPP-003') {
      return context.appLocalization.appMsg003;
    }
    if (code.trim() == 'MSGAPP-004') {
      return context.appLocalization.appMsg004;
    }
    if (code.trim() == 'MSGAPP-005') {
      return context.appLocalization.appMsg005;
    }
    if (code.trim() == 'MSGAPP-006') {
      return context.appLocalization.appMsg006;
    }
    if (code.trim() == 'MSGAPP-007') {
      return context.appLocalization.appMsg007;
    }
    if (code.trim() == 'MSGAPP-008') {
      return context.appLocalization.appMsg008;
    }
    if (code.trim() == 'MSGAPP-009') {
      return context.appLocalization.appMsg009;
    }
    if (code.trim() == 'MSGAPP-010') {
      return context.appLocalization.appMsg010;
    }
    if (code.trim() == 'MSGAPP-011') {
      return context.appLocalization.appMsg011;
    }
    return code;
  }
}
