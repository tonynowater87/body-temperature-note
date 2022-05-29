abstract class SettingsProvider {
  Future<bool> setIsDarkMode(bool isDarkMode);

  bool? getIsDarkMode();

  Future<bool> setIsCelsius(bool isCelsius);

  bool getIsCelsius();

  Future<bool> setLanguageCode(String languageCode);

  String? getLanguageCode();

  Future<bool> setBaseline(double baseline);

  double getBaseline();

  Future<bool> setIsDisplayBaseline(bool isDisplayBaseline);

  bool getIsDisplayBaseline();
}
