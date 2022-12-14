import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/provider/firebase_cloud_store_record_provider.dart';
import 'package:body_temperature_note/data/provider/hive_memo_provider.dart';
import 'package:body_temperature_note/data/provider/hive_record_provider.dart';
import 'package:body_temperature_note/data/provider/setting_provider.dart';
import 'package:body_temperature_note/data/provider/settings_provider_impl.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/data/repository/repository.dart';
import 'package:body_temperature_note/firebase_options.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/theme/cubit/theme_cubit.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:body_temperature_note/theme/theme_data.dart';
import 'package:body_temperature_note/utils/app_bloc_observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

Future<void> main() async {
  const appName = "BodyTemperatureNote";

  final costTimeForLaunch = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: appName, options: DefaultFirebaseOptions.currentPlatform);

  // init hive & hive_data_provider
  await Hive.initFlutter("RecordDB");
  Hive.registerAdapter(HiveRecordAdapter());
  Hive.registerAdapter(HiveMemoAdapter());
  final hiveRecordBox = await Hive.openBox<HiveRecord>("RecordDB");
  final hiveRecordProvider = HiveRecordProvider(hiveRecordBox);
  final hiveMemoBox = await Hive.openBox<HiveMemo>("MemoDB");
  final hiveMemoProvider = HiveMemoProvider(hiveMemoBox);

  // init fireStore
  final fireStore = FirebaseFirestore.instanceFor(app: Firebase.app(appName));
  final fireStoreRecordProvider = FirebaseCloudStoreRecordProvider(fireStore);

  getIt.registerLazySingleton<Logger>(
      () => Logger(printer: SimplePrinter(printTime: true, colors: false)));

  // init sharedPreference
  final sharedPreferences = await SharedPreferences.getInstance();
  final settingsProvider = SettingsProviderImpl(sharedPreferences);

  //0:00:00.100910
  //0:00:00.060453
  //0:00:00.059683
  print('[Tony] ${costTimeForLaunch.difference(DateTime.now())})');

  BlocOverrides.runZoned(() {
    runApp(MyApp(
      hiveRecordProvider: hiveRecordProvider,
      hiveMemoProvider: hiveMemoProvider,
      firebaseCloudStoreRecordProvider: fireStoreRecordProvider,
      settingsProvider: settingsProvider,
    ));
  }, blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  HiveRecordProvider hiveRecordProvider;
  HiveMemoProvider hiveMemoProvider;
  FirebaseCloudStoreRecordProvider firebaseCloudStoreRecordProvider;
  SettingsProvider settingsProvider;

  MyApp(
      {Key? key,
      required this.hiveRecordProvider,
      required this.hiveMemoProvider,
      required this.firebaseCloudStoreRecordProvider,
      required this.settingsProvider})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Repository>(
            create: (BuildContext context) => RecordRepository(
                hiveRecordProvider: hiveRecordProvider,
                hiveMemoProvider: hiveMemoProvider,
                firebaseCloudStoreRecordProvider:
                    firebaseCloudStoreRecordProvider)),
        RepositoryProvider<SettingsProvider>(
            create: (BuildContext context) => settingsProvider)
      ],
      child: BlocProvider<ThemeCubit>(
        create: (context) => ThemeCubit(settingsProvider),
        child: BlocBuilder<ThemeCubit, AppThemeDataState>(
          builder: (context, state) {
            return MaterialApp.router(
              theme: AppTheme.light.getThemeData(),
              darkTheme: AppTheme.nord.getThemeData(),
              themeMode: state.appThemeMode,
              locale: state.appLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              routerDelegate: _appRouter.delegate(),
              routeInformationParser: _appRouter.defaultRouteParser(),
            );
          },
        ),
      ),
    );
  }
}
