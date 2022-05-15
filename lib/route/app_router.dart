import 'package:auto_route/annotations.dart';
import 'package:body_temperature_note/views/chart_page.dart';
import 'package:body_temperature_note/views/home/home_page.dart';
import 'package:body_temperature_note/views/input/input_page.dart';
import 'package:body_temperature_note/views/settings/settings_page.dart';

@MaterialAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: HomePage, initial: true),
  AutoRoute<bool>/* generic is result type */(page: InputPage),
  AutoRoute(page: ChartPage),
  AutoRoute(page: SettingsPage),
])
class $AppRouter {}
