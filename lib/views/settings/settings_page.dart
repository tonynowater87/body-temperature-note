import 'dart:io';

import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/l10n/l10n.dart';
import 'package:body_temperature_note/main.dart';
import 'package:body_temperature_note/theme/cubit/theme_cubit.dart';
import 'package:body_temperature_note/theme/theme_data.dart';
import 'package:body_temperature_note/views/settings/cubit/settings_cubit.dart';
import 'package:body_temperature_note/views/settings/cubit/settings_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  final void Function(bool) onResult;

  SettingsPage({Key? key, required this.onResult}) : super(key: key);

  final _logger = getIt<Logger>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _logger.d("onPop");
        onResult.call(true);
        return true;
      },
      child: BlocProvider(
        create: (context) => SettingsCubit(context.read<SettingsProvider>()),
        child: BlocConsumer<SettingsCubit, SettingsState>(
          listener: (consumerContext, state) {
            _logger.d("setting state changed = $state");
            consumerContext.read<ThemeCubit>().changeLocale(state.locale);
          },
          builder: (context, state) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (builderContext, state) {
                return Scaffold(
                  appBar: AppBar(
                    iconTheme: Theme.of(context).iconTheme,
                    title: Text(
                      context.l10n.setting_title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  body: SettingsList(
                      lightTheme: AppTheme.light.getSettingsThemeData(),
                      darkTheme: AppTheme.dark.getSettingsThemeData(),
                      sections: [
                        SettingsSection(title: Text('Common'), tiles: [
                          SettingsTile.switchTile(
                            initialValue: state.isDarkMode,
                            leading: const Icon(Icons.mode_night_outlined),
                            activeSwitchColor: Theme.of(context).primaryColor,
                            onToggle: (value) {
                              builderContext.read<ThemeCubit>().toggle();
                              builderContext
                                  .read<SettingsCubit>()
                                  .updateIsDarkMode(value);
                            },
                            title: Text('開啟DarkMode'),
                          ),
                          SettingsTile.switchTile(
                            initialValue: state.isDisplayBaseline,
                            leading: const Icon(Icons.line_axis_outlined),
                            activeSwitchColor: Theme.of(context).primaryColor,
                            onToggle: (value) {
                              builderContext
                                  .read<SettingsCubit>()
                                  .updateIsDisplayBaseline(value);
                            },
                            title: Text('是否顯示水平基準線'),
                          ),
                          SettingsTile.navigation(
                            onPressed: (context) {
                              if (Platform.isAndroid) {
                                showModalPopupForiOS(builderContext); //TODO
                              } else if (Platform.isIOS) {
                                showModalPopupForiOS(builderContext);
                              }
                            },
                            title: Text('Language'),
                            leading: const Icon(Icons.language_outlined),
                            trailing: Text(state.locale.languageCode),
                          )
                        ]),
                        SettingsSection(title: Text('Others'), tiles: [
                          SettingsTile.navigation(
                            title: Text('攝氏/華氏'),
                            leading: const Icon(Icons.app_settings_alt),
                            trailing: Text(state.isCelsius ? '攝氏' : '華氏'),
                            onPressed: (context) {
                              showCupertinoModalPopup(
                                  builder: (BuildContext context) {
                                    return CupertinoActionSheet(
                                      title: Text('Select Language'),
                                      actions: <CupertinoActionSheetAction>[
                                        CupertinoActionSheetAction(
                                          child: Text('攝氏'),
                                          onPressed: () {
                                            builderContext
                                                .read<SettingsCubit>()
                                                .updateIsCelsius(true);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text('華氏'),
                                          onPressed: () {
                                            builderContext
                                                .read<SettingsCubit>()
                                                .updateIsCelsius(false);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text('取消'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  },
                                  context: context);
                            },
                          )
                        ])
                      ]),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showModalPopupForiOS(BuildContext builderContext) {
    showCupertinoModalPopup(
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Select Language'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: Text('English'),
                onPressed: () {
                  builderContext
                      .read<SettingsCubit>()
                      .updateLocale(Locale('en'));
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('日本語'),
                onPressed: () {
                  builderContext
                      .read<SettingsCubit>()
                      .updateLocale(Locale('ja'));
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text('中文'),
                onPressed: () {
                  builderContext
                      .read<SettingsCubit>()
                      .updateLocale(Locale('zh'));
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        },
        context: builderContext);
  }
}
