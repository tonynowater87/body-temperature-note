import 'package:body_temperature_note/utils/double_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test 0°C to 32°F', () {
    expect(0.0.toFahrenheit(), 32);
  });

  test('test 35.0°C to 95.00°F', () {
    expect(35.0.toFahrenheit(), 95.00);
  });

  test('test 45.0°C to 113.00°F', () {
    expect(45.0.toFahrenheit(), 113.00);
  });

  test('test 113.00°F to 45.0°C', () {
    expect(113.0.toCelsius(), 45.00);
  });

  test('test 95.00°F to 35.0°C', () {
    expect(95.0.toCelsius(), 35.00);
  });

  test('test 32°F to 0°C', () {
    expect(32.0.toCelsius(), 0.0);
  });
}
