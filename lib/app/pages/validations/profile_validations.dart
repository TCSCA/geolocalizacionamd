import 'package:flutter/cupertino.dart';
import 'package:geolocalizacionamd/app/extensions/localization_ext.dart';

class ProfileValidations {
  fullnameValidator(BuildContext context, String event) {
    final RegExp regExp =
        RegExp(r"^[A-Za-zéáíóúñÁÉÍÓÚÑ'\s]+(?: [A-Za-zéáíóúñÁÉÍÓÚÑ']+)*$");
    if (!regExp.hasMatch(event) && event != '') {
      return context.appLocalization.invalidData;
    } else {
      if (event.length > 50) {
        return 'maxLength';
      } else if (event.length < 6 && event != '') {
        return context.appLocalization.invalidLengthField;
      } else if (event == '') {
        return context.appLocalization.fieldRequired;
      }
    }
    return null;
  }

  emailValidator(BuildContext context, String event) {
    final RegExp regExp = RegExp(
        r"^(([a-zA-Z0-9]([\.\-\_]){1})|([a-zA-Z0-9]))+@[a-zA-Z0-9]+\.(([a-zA-Z]{2,4}|[a-zA-Z]{1,3}\.[a-zA-Z]{1,2}))+$");

    if (!regExp.hasMatch(event) && event != '') {
      return context.appLocalization.invalidData;
    } else {
      if (event.length > 60) {
        return 'maxLength';
      } else if (event.length < 6 && event != '') {
        return context.appLocalization.invalidLengthField;
      } else if (event == '') {
        return context.appLocalization.fieldRequired;
      }
    }
    return null;
  }

  numberValidator(BuildContext context, String event) {
    if (event != '' && event.substring(1).startsWith('0')) {
      return 'No esta permitido el numero 0 al inicio';
    } else if (event.length < 13 && event != '') {
      return context.appLocalization.invalidLengthField;
    } else if (event == '') {
      return context.appLocalization.fieldRequired;
    }
    return null;
  }

  otherNumberValidator(BuildContext context, String event) {
    if (event != '' && event.substring(1).startsWith('0')) {
      return 'No esta permitido el numero 0 al inicio';
    } else if (event.length < 13 && event != '') {
      return context.appLocalization.invalidLengthField;
    }
    return null;
  }

  directionValidator(BuildContext context, String event) {
    if (event != "" && event.length < 4) {
      return context.appLocalization.invalidLengthField;
    } else if (event == '') {
      return context.appLocalization.fieldRequired;
    }
    return null;
  }

  genderValidator(BuildContext context, String event) {
    if (event == 'null' || event == '') {
      return context.appLocalization.fieldRequired;
    }
    return null;
  }

  mppsValidator(BuildContext context, String event) {
    RegExp regExp = RegExp(r"^[0-9]+$");
    if (event == 'null' || event == '') {
      return context.appLocalization.fieldRequired;
    } else {
      if (!regExp.hasMatch(event) || event[0] == '0') {
        return context.appLocalization.invalidData;
      } else if (event.length < 4) {
        return context.appLocalization.invalidLengthField;
      }
    }
    return null;
  }

  cmValidator(BuildContext context, String event) {
    RegExp regExp = RegExp(r"^[0-9]+$");
    if (event == 'null' || event == '') {
      return context.appLocalization.fieldRequired;
    } else {
      if (!regExp.hasMatch(event) || event[0] == '0') {
        return context.appLocalization.invalidData;
      } else if (event.isEmpty) {
        return context.appLocalization.invalidLengthField;
      }
    }
    return null;
  }

  specialityValidator(BuildContext context, String event) {
    if (event == 'null' || event == '') {
      return context.appLocalization.fieldRequired;
    }
    return null;
  }

  bdValidator(BuildContext context, String event) {
    if (event == '') {
      return context.appLocalization.fieldRequired;
    }

    return null;
  }
}
