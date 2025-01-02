import 'package:get/get.dart';

import '../consts/app_formatters.dart';

class Validations {
  Validations._();

  static String? checkEmailValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_email".tr;
    }
    return null;
  }

  static String? checkPasswordValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_password".tr;
    }
    return null;
  }

  static String? checkNameValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_name".tr;
    } else if (!AppFormatters.validNameExp.hasMatch(enteredValue)) {
      return "message_enter_valid_name".tr;
    } else {
      return null;
    }
  }

  static String? checkContactNoValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_contact_number".tr;
    } else if (enteredValue.length < 4) {
      return "message_enter_minimum_four_digits".tr;
    } else if (enteredValue.length > 12) {
      return "message_enter_maximum_twelve_digits".tr;
    } else if (!AppFormatters.validContactNoExp.hasMatch(enteredValue)) {
      return "message_enter_valid_contact_number".tr;
    } else {
      return null;
    }
  }

  static String? checkAlternateContactNoValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_alternate_number".tr;
    } else if (enteredValue.length < 4) {
      return "message_enter_minimum_four_digits".tr;
    } else if (enteredValue.length > 12) {
      return "message_enter_maximum_twelve_digits".tr;
    } else if (enteredValue.isNotEmpty &&
        !AppFormatters.validContactNoExp.hasMatch(enteredValue)) {
      return "message_enter_valid_alternate_number".tr;
    } else {
      return null;
    }
  }

  static String? checkDateOfBirthValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_date_of_birth".tr;
    } else {
      return null;
    }
  }

  static String? checkCurrentAddressValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_current_address".tr;
    } else {
      return null;
    }
  }

  static String? checkAdditionalInfoValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_additional_info".tr;
    } else {
      return null;
    }
  }
}
