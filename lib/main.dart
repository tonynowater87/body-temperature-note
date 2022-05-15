import 'package:body_temperature_note/data/model/hive_memo.dart';
import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/provider/firebase_cloud_store_record_provider.dart';
import 'package:body_temperature_note/data/provider/hive_memo_provider.dart';
import 'package:body_temperature_note/data/provider/hive_record_provider.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/firebase_options.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/theme/cubit/theme_cubit.dart';
import 'package:body_temperature_note/theme/cubit/theme_state.dart';
import 'package:body_temperature_note/theme/theme_data.dart';
import 'package:body_temperature_note/utils/app_bloc_observer.dart';
import 'package:body_temperature_note/views/home/cubit/home_cubit.dart';
import 'package:body_temperature_note/views/input/cubit/input_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

Future<void> main() async {
  const appName = "BodyTemperatureNote";

  //final costTimeForLaunch = DateTime.now();
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

  //0:00:00.100910
  //0:00:00.060453
  //0:00:00.059683
  //print('[Tony] ${costTimeForLaunch.difference(DateTime.now())})');

  BlocOverrides.runZoned(() {
    runApp(MyApp(
      hiveRecordProvider: hiveRecordProvider,
      hiveMemoProvider: hiveMemoProvider,
      firebaseCloudStoreRecordProvider: fireStoreRecordProvider,
    ));
  }, blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  HiveRecordProvider hiveRecordProvider;
  HiveMemoProvider hiveMemoProvider;
  FirebaseCloudStoreRecordProvider firebaseCloudStoreRecordProvider;

  MyApp({
    Key? key,
    required this.hiveRecordProvider,
    required this.hiveMemoProvider,
    required this.firebaseCloudStoreRecordProvider,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RecordRepository>(
            create: (BuildContext context) => RecordRepository(
                hiveRecordProvider: hiveRecordProvider,
                hiveMemoProvider: hiveMemoProvider,
                firebaseCloudStoreRecordProvider:
                    firebaseCloudStoreRecordProvider))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
              create: (BuildContext context) => ThemeCubit()),
          BlocProvider<HomeCubit>(
              create: (BuildContext context) =>
                  HomeCubit(repository: RepositoryProvider.of(context))),
          BlocProvider<InputCubit>(
              create: (BuildContext context) =>
                  InputCubit(repository: RepositoryProvider.of(context))),
        ],
        child: BlocBuilder<ThemeCubit, AppThemeDataState>(
          builder: (context, state) {
            return MaterialApp.router(
              theme: AppTheme.light.getThemeData(),
              darkTheme: AppTheme.dark.getThemeData(),
              themeMode: state.appThemeMode,
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
