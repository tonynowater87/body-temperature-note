// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/cupertino.dart' as _i7;
import 'package:flutter/material.dart' as _i6;

import '../views/chart_page.dart' as _i3;
import '../views/home/home_page.dart' as _i1;
import '../views/input/input_page.dart' as _i2;
import '../views/settings/settings_page.dart' as _i4;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    InputPageRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<InputPageRouteArgs>(
          orElse: () =>
              InputPageRouteArgs(dateString: pathParams.getString('argument')));
      return _i5.MaterialPageX<bool>(
          routeData: routeData,
          child: _i2.InputPage(dateString: args.dateString));
    },
    ChartPageRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i3.ChartPage());
    },
    SettingsPageRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsPageRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.SettingsPage(key: args.key, onResult: args.onResult));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(HomePageRoute.name, path: '/'),
        _i5.RouteConfig(InputPageRoute.name, path: '/input-page'),
        _i5.RouteConfig(ChartPageRoute.name, path: '/chart-page'),
        _i5.RouteConfig(SettingsPageRoute.name, path: '/settings-page')
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomePageRoute extends _i5.PageRouteInfo<void> {
  const HomePageRoute() : super(HomePageRoute.name, path: '/');

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i2.InputPage]
class InputPageRoute extends _i5.PageRouteInfo<InputPageRouteArgs> {
  InputPageRoute({required String dateString})
      : super(InputPageRoute.name,
            path: '/input-page',
            args: InputPageRouteArgs(dateString: dateString),
            rawPathParams: {'argument': dateString});

  static const String name = 'InputPageRoute';
}

class InputPageRouteArgs {
  const InputPageRouteArgs({required this.dateString});

  final String dateString;

  @override
  String toString() {
    return 'InputPageRouteArgs{dateString: $dateString}';
  }
}

/// generated route for
/// [_i3.ChartPage]
class ChartPageRoute extends _i5.PageRouteInfo<void> {
  const ChartPageRoute() : super(ChartPageRoute.name, path: '/chart-page');

  static const String name = 'ChartPageRoute';
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsPageRoute extends _i5.PageRouteInfo<SettingsPageRouteArgs> {
  SettingsPageRoute({_i7.Key? key, required void Function(bool) onResult})
      : super(SettingsPageRoute.name,
            path: '/settings-page',
            args: SettingsPageRouteArgs(key: key, onResult: onResult));

  static const String name = 'SettingsPageRoute';
}

class SettingsPageRouteArgs {
  const SettingsPageRouteArgs({this.key, required this.onResult});

  final _i7.Key? key;

  final void Function(bool) onResult;

  @override
  String toString() {
    return 'SettingsPageRouteArgs{key: $key, onResult: $onResult}';
  }
}
