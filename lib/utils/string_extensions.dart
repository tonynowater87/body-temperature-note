import 'dart:ui';

import 'package:sprintf/sprintf.dart';

extension StringExtension on String {
  String format(List<dynamic> argument) => sprintf.call(this, argument);
}

extension ColorExtension on String {
  Color? toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceAll('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }
    return null;
  }
}
