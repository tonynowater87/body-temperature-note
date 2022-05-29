import 'package:body_temperature_note/data/provider/setting_provider.dart';

class FakeSettingsProvider extends SettingsProvider {
  late bool isCelsius;
  late bool isDisplayBaseline;
  late double baseline;

  @override
  bool getIsCelsius() {
    return isCelsius;
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
    return baseline;
  }

  @override
  Future<bool> setBaseline(double baseline) {
    // TODO: implement setBaseline
    throw UnimplementedError();
  }

  @override
  bool getIsDisplayBaseline() {
    return isDisplayBaseline;
  }

  @override
  Future<bool> setIsDisplayBaseline(bool isDisplayBaseline) {
    // TODO: implement setIsDisplayBaseline
    throw UnimplementedError();
  }

  FakeSettingsProvider({
    required this.isCelsius,
    required this.isDisplayBaseline,
    required this.baseline,
  });
}
