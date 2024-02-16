import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuxController {
  static bool validateEmail(String email) {
    // Expresión regular para verificar el formato del correo electrónico
    String emailPattern =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  static bool validatePasswords(String password, String passwordConf) {
    // La contraseña debe contener al menos 10 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número.
    String passwordPattern = r'^[a-zA-Z0-9#+*\-.,;:_()\/]{15,}$';
    RegExp regex = RegExp(passwordPattern);

    if (password != passwordConf) {
      return false;
    }
    return regex.hasMatch(password);
  }

  void clearTextField(TextEditingController controller) {
    controller.clear();
  }

  String generateId() {
    var uuid = const Uuid();
    return uuid.v4();
  }

  bool checkPasswordRequirements(String password) {
    // La contraseña debe contener al menos 15 caracteres, incluyendo al menos una letra mayúscula, una minúscula y un número.
    String passwordPattern = r'^[a-zA-Z0-9#+*\-.,;:_()\/]{15,}$';
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  String getFechaActual() {
    DateTime fecha = DateTime.now();

    String fechaFormateada =
        '${fecha.year}-${_formatNumber(fecha.month)}-${_formatNumber(fecha.day)} '
        '${_formatNumber(fecha.hour)}:${_formatNumber(fecha.minute)}:${_formatNumber(fecha.second)}';

    return fechaFormateada;
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  bool isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.length == 10;
  }

  bool isPasswordLengthValid(String password) {
    return password.length <= 15;
  }
}
