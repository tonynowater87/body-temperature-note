import 'package:sprintf/sprintf.dart';

extension StringExtension on String {
  String format(List<dynamic> argument) => sprintf.call(this, argument);
}
