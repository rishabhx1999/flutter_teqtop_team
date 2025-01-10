import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManager {
  static const prefIsLogin = "pref_key_is_user_login";
  static const prefLoginDate = "pref_key_login_date";
  static const prefUserToken = "pref_key_user_token";
  static const prefUserProfilePhoto = "pref_key_user_profile_photo";
  static const prefUserName = "pref_key_user_name";
  static const prefUserEmail = "pref_key_user_email";
  static const prefUserContactNumber = "pref_key_user_contact_number";
  static const prefUserAlternateNumber = "pref_key_user_alternate_number";
  static const prefUserDateOfBirth = "pref_key_user_date_of_birth";
  static const prefUserCurrentAddress = "pref_key_user_current_address";
  static const prefUserAdditionalInfo = "pref_key_user_additional_info";

  static late SharedPreferences _prefs;

  PreferenceManager._();

  static Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> init() async {
    _prefs = await _getInstance();
    return Future.value(true);
  }

  static Object? getPref(String key) {
    return _prefs.get(key);
  }

  static bool isUserLoggedIn() {
    bool? isLogin = getPref(prefIsLogin) as bool?;
    return isLogin ?? false;
  }

  static void saveToPref(String key, dynamic value) {
    if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is String) {
      _prefs.setString(key, value);
    }
  }

  static void remove(String key) {
    _prefs.remove(key);
  }

  static void clean() {
    _prefs.clear();
  }
}
