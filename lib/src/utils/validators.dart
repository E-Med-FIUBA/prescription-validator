import 'package:flutter/material.dart';

enum Validators { email, strongPassword, number, required }

final passwordRegex =
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

class FormInputValidator {
  final List<Validators> validators;
  final Key key;

  FormInputValidator(this.validators, this.key);

  String? validate(String? value) {
    for (final validator in validators) {
      final validateFn = selectValidatorFn(validator);

      final result = validateFn(key, value);

      if (result != null) {
        return result;
      }
    }

    return null;
  }

  String? Function(Key key, String? value) selectValidatorFn(
      Validators validator) {
    switch (validator) {
      case Validators.email:
        return validateEmail;
      case Validators.strongPassword:
        return validatePasswordInput;
      case Validators.number:
        return validateNumber;
      case Validators.required:
        return validateEmptyInput;
      default:
        return (Key key, String? value) => null;
    }
  }

  String? validateEmail(Key key, String? value) {
    if (value == null) {
      return 'Ingrese un ${key.toString().toLowerCase()}';
    }

    if (!emailRegex.hasMatch(value)) {
      return 'El email ingresado no es valido';
    }
    return null;
  }

  String? validateEmptyInput(
    Key key,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un ${key.toString().toLowerCase()}';
    }
    return null;
  }

  String? validatePasswordInput(Key key, String? value) {
    if (value == null) {
      return 'Ingrese un ${key.toString().toLowerCase()}';
    }

    if (!passwordRegex.hasMatch(value)) {
      return 'La contraseña no es segura';
    }
    return null;
  }

  String? validateNumber(Key key, String? value) {
    if (value == null || !isNumeric(value)) {
      return 'Ingrese un numero';
    }

    return null;
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
