import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConstants {
  AppConstants._();
  static const String environmentVariableName = 'ENVIRONMENT';
  static const String languageCodeEn = 'en';
  static const String languageCodeEs = 'es';
  static const String profileDefaultImage = 'assets/images/profile_default.png';
  static const String backgroundHeaderMenuImage =
      'assets/images/background_header_menu.jpg';

  static const String codeGeneralErrorMessage = 'MSG-001';

  static const String statusError = 'error';
  static const String statusWarning = 'warning';
  static const String statusSuccess = 'success';

  static const Map<String, IconData> iconsMenu = {
    'home': FontAwesomeIcons.house,
    'profile': FontAwesomeIcons.idCardClip,
    'medicalCareHome': FontAwesomeIcons.houseMedical,
    'medicalCareAccepted': FontAwesomeIcons.houseMedicalFlag,
    'medicalCareProcessed': FontAwesomeIcons.houseMedicalCircleCheck,
    'medicalCareRefused': FontAwesomeIcons.houseMedicalCircleXmark,
    'logout': FontAwesomeIcons.rightFromBracket,
    'aboutApp': FontAwesomeIcons.circleInfo,
    'closeMenu': FontAwesomeIcons.xmark,
    statusError: FontAwesomeIcons.xmark,
    statusWarning: FontAwesomeIcons.triangleExclamation,
    statusSuccess: FontAwesomeIcons.check
  };
}
