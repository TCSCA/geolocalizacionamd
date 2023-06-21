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
      return 'El Usuario no se encuentra registrado.';
    }
    if (code.trim() == 'MSG-057') {
      return context.appLocalization.apiMsg057;
    }
    if (code.trim() == 'MSGAPP-001') {
      return 'Ya se encuentra disponible para atender';
    }
    if (code.trim() == 'MSGAPP-002') {
      return 'No se tiene permisos para procesar solicitud';
    }
    if (code.trim() == 'MSGAPP-003') {
      return 'Servicio de localizacion no activo en tu dispositivo';
    }
    if (code.trim() == 'MSGAPP-004') {
      return 'No se pudo confirmar la atención médica';
    }
    if (code.trim() == 'MSGAPP-005') {
      return 'No se pudo rechazar la atención médica';
    }
    if (code.trim() == 'MSGAPP-006') {
      return 'La atención fue rechazada con éxito';
    }
    if (code.trim() == 'MSGAPP-007') {
      return 'La atención fue finalizada con éxito';
    }
    if (code.trim() == 'MSGAPP-008') {
      return 'No tienes órdenes pendientes para atender en este momento.';
    }
    return code;
  }
}
