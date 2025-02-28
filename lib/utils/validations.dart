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

  static String? checkProfileValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_profile".tr;
    } else if (!AppFormatters.validNameExp.hasMatch(enteredValue)) {
      return "message_enter_valid_profile".tr;
    } else {
      return null;
    }
  }

  static String? checkURLValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_url".tr;
    } else if (!AppFormatters.validUrlExp.hasMatch(enteredValue)) {
      return "message_enter_valid_url".tr;
    } else {
      return null;
    }
  }

  static String? checkPortalValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_portal".tr;
    } else if (!AppFormatters.validUrlExp.hasMatch(enteredValue)) {
      return "message_enter_valid_portal".tr;
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

  static String? checkStartDateValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_start_date".tr;
    } else {
      return null;
    }
  }

  static String? checkEndDateValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_end_date".tr;
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

  static String? checkProjectDescriptionValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_project_description".tr;
    } else {
      return null;
    }
  }

  static String? checkTaskDescriptionValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_task_description".tr;
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

  static String? checkProjectNameValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_project_name".tr;
    } else {
      return null;
    }
  }

  static String? checkTaskNameValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_task_name".tr;
    } else {
      return null;
    }
  }

  static String? checkFolderNameValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_folder_name".tr;
    }
    return null;
  }

  static String? checkRoleValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_role".tr;
    }
    return null;
  }

  static String? checkPositionValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_position".tr;
    }
    return null;
  }

  static String? checkEmployeeIDValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_employee_id".tr;
    }
    return null;
  }

  static String? checkAssignHoursValidations(String? value) {
    var enteredValue = value?.trim() ?? '';
    if (enteredValue.isEmpty) {
      return "message_enter_assign_hours".tr;
    }
    return null;
  }
}
