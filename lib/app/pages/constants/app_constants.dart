import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppConstants {
  AppConstants._();
  static const String environmentVariableName = 'ENVIRONMENT';
  static const String environmentDevelopment = 'DEV';
  static const String environmentTesting = 'QA';
  static const String environmentProduction = 'PROD';
  static const String languageCodeEn = 'en';
  static const String languageCodeEs = 'es';
  static const String profileDefaultImage = 'assets/images/profile_default.png';
  static const String backgroundHeaderMenuImage =
      'assets/images/background_header_menu.jpg';

  static const String logoImageBlue =
      'assets/images/telemedicina24_logo_azul_lineal.png';
  static const String logoImageWhite =
      'assets/images/telemedicina24_logo_blanco_lineal.png';

  static const String codeGeneralErrorMessage = 'MSG-001';
  static const String codeDoctorInAttention = 'MSGAPP-008';

  static const String statusError = 'error';
  static const String statusWarning = 'warning';
  static const String statusSuccess = 'success';

  static const String idCountryVzla = '25';

  static const Map<String, IconData?> iconsMenu = {
    'home': FontAwesomeIcons.house,
    'profile': FontAwesomeIcons.idCardClip,
    'medicalCareHome': FontAwesomeIcons.houseMedical,
    'medicalCareAccepted': FontAwesomeIcons.houseMedicalFlag,
    'medicalCareProcessed': FontAwesomeIcons.houseMedicalCircleCheck,
    'medicalCareRefused': FontAwesomeIcons.houseMedicalCircleXmark,
    'changePassword': FontAwesomeIcons.keycdn,
    'logout': FontAwesomeIcons.rightFromBracket,
    'aboutApp': FontAwesomeIcons.circleInfo,
    'closeMenu': FontAwesomeIcons.xmark,
    statusError: FontAwesomeIcons.xmark,
    statusWarning: FontAwesomeIcons.triangleExclamation,
    statusSuccess: FontAwesomeIcons.check,
    'doctorLocation': FontAwesomeIcons.locationDot
  };
}
