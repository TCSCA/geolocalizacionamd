class PasswordValidation {


  passwordValidator(String event) {
    final RegExp regExp = RegExp(
        r"^(?=.*[0-9])(?=.*[.,_#-])(?=.*[A-Z])(?=.*[a-z])[a-zA-Z0-9.,#_-]{6,}$");
    if (!regExp.hasMatch(event) && event != '') {
      return 'El campo Contraseña debe cumplir las  especificaciones: \nAl menos una letra en mayúscula.\n'
          'Al menos una letra en minúscula.\nAl menos un valor numérico.\n'
          'Al menos un caracter especial.\nCaracteres: _- . , #\n'
          'Mínimo: 6 caracteres.\nMáximo: 12 caracteres.';
    } else {
      if (event.length > 12) {
        return 'maxLength';
      } else if (event.length < 6 && event != '') {
        return 'El Campo debe ser mayor a 6 caracteres';
      } else if (event == '') {
        return 'El campo es reuerido';
      }
    }
    return null;
  }

  confirmPasswordValidator(String event, String password) {
    final RegExp regExp = RegExp(
        r"^(?=.*[0-9])(?=.*[.,_#-])(?=.*[A-Z])(?=.*[a-z])[a-zA-Z0-9.,_#-]{6,}$");
    if (password != event) {
      return 'La contraseña no coinciden';
    }

    if (event.length > 12) {
      return 'maxLength';
    } else if (event.length < 6 && event != '') {
      return 'debe ser mayor o igual a 6 caracteres';
    } else if (event == '') {
      return 'Campo requerido';
    }

    return null;
  }

}