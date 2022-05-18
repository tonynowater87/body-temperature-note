extension DoubleX on double {
  double toFahrenheit() {
    return this * 9 / 5 + 32;
  }

  double toCelsius() {
    return (this - 32.0) * 5 / 9;
  }
}
