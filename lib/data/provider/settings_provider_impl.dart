import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProviderImpl extends SettingsProvider {
  static const keyIsDarkMode = 'keyIsDarkMode';
  static const keyIsCelsius = 'keyIsCelsius';
  static const keyLanguageCode = 'keyLanguageCode';

  late SharedPreferences sharedPreferences;

  SettingsProviderImpl(this.sharedPreferences);

  @override
  Future<bool> setIsDarkMode(bool isDarkMode) {
    return sharedPreferences.setBool(keyIsDarkMode, isDarkMode);
  }

  @override
  bool? getIsDarkMode() {
    return sharedPreferences.getBool(keyIsDarkMode);
  }

  @override
  Future<bool> setIsCelsius(bool isCelsius) {
    return sharedPreferences.setBool(keyIsCelsius, isCelsius);
  }

  @override
  bool getIsCelsius() {
    return sharedPreferences.getBool(keyIsCelsius) ?? true;
  }

  @override
  Future<bool> setLanguageCode(String languageCode) {
    return sharedPreferences.setString(keyLanguageCode, languageCode);
  }

  @override
  String? getLanguageCode() {
    return sharedPreferences.getString(keyLanguageCode);
  }
}
