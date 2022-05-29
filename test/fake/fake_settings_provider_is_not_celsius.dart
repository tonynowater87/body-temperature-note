import 'package:body_temperature_note/data/provider/setting_provider.dart';

class FakeIsNotCelsiusSettingsProvider extends SettingsProvider {
  @override
  bool getIsCelsius() {
    return false;
  }

  @override
  bool? getIsDarkMode() {
    // TODO: implement getIsDarkMode
    throw UnimplementedError();
  }

  @override
  String? getLanguageCode() {
    // TODO: implement getLanguageCode
    throw UnimplementedError();
  }

  @override
  Future<bool> setIsCelsius(bool isCelsius) {
    // TODO: implement setIsCelsius
    throw UnimplementedError();
  }

  @override
  Future<bool> setIsDarkMode(bool isDarkMode) {
    // TODO: implement setIsDarkMode
    throw UnimplementedError();
  }

  @override
  Future<bool> setLanguageCode(String languageCode) {
    // TODO: implement setLanguageCode
    throw UnimplementedError();
  }

  @override
  double getBaseline() {
    return 37.7;
  }

  @override
  Future<bool> setBaseline(double baseline) {
    // TODO: implement setBaseline
    throw UnimplementedError();
  }
}
