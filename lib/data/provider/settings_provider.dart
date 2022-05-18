import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider {
  static const keyIsDarkMode = 'keyIsDarkMode';
  static const keyIsCelsius = 'keyIsCelsius';
  static const keyLanguageCode = 'keyLanguageCode';

  SharedPreferences sharedPreferences;

  SettingsProvider(this.sharedPreferences);

  Future<bool> setIsDarkMode(bool isDarkMode) {
    return sharedPreferences.setBool(keyIsDarkMode, isDarkMode);
  }

  bool? getIsDarkMode() {
    return sharedPreferences.getBool(keyIsDarkMode);
  }

  Future<bool> setIsCelsius(bool isCelsius) {
    return sharedPreferences.setBool(keyIsCelsius, isCelsius);
  }

  bool getIsCelsius() {
    return sharedPreferences.getBool(keyIsCelsius) ?? true;
  }

  Future<bool> setLanguageCode(String languageCode) {
    return sharedPreferences.setString(keyLanguageCode, languageCode);
  }

  String? getLanguageCode() {
    return sharedPreferences.getString(keyLanguageCode);
  }
}
