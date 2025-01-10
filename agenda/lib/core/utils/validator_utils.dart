import 'package:agenda/core/utils/regex_utilis.dart';
import 'package:flutter/cupertino.dart';
import '../costants/string_constants.dart';

/// Utility class to management validators for form

class ValidatorUtils {
  static String? validateText(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.validatorMessageValidText;
    } else {
      if (!RegexUtils.regexText.hasMatch(value)) {
        return StringConstants.validatorMessageValidText;
      } else {
        return null;
      }
    }
  }

  static String? validatePassword(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegexUtils.regexPassword.hasMatch(value)) {
        return StringConstants.validatorMessagePassword;
      } else {
        return null;
      }
    } else {
      return StringConstants.validatorMessageValidPassword;
    }
  }

  static String? validateConfirmPassword(
      String? password, TextEditingController? checkEditingControllerPassword) {
    if (password != null &&
        password.isNotEmpty &&
        checkEditingControllerPassword != null) {
      if (password != checkEditingControllerPassword.text) {
        return StringConstants.validatorMessageConfirmPassword;
      } else {
        return null;
      }
    } else {
      return StringConstants.validatorMessageValidPassword;
    }
  }

  static String? validateEmail(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegexUtils.regexEmail.hasMatch(value)) {
        return StringConstants.validatorMessageValidEmail;
      } else {
        return null;
      }
    } else {
      return StringConstants.validatorMessageValidEmail;
    }
  }

  static String? validateDouble(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.validatorMessageValidDouble;
    } else {
      double? parsedValue = double.tryParse(value);
      if (parsedValue == null) {
        return StringConstants.validatorMessageValidDouble;
      } else {
        return null;
      }
    }
  }

  static String? validateInteger(String? value) {
    if (value == null || value.isEmpty) {
      return StringConstants.validatorMessageValidInteger;
    } else {
      int? parsedValue = int.tryParse(value);
      if (parsedValue == null) {
        return StringConstants.validatorMessageValidInteger;
      } else {
        return null;
      }
    }
  }
}
