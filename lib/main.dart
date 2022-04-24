import 'package:body_temperature_note/data/model/hive_record.dart';
import 'package:body_temperature_note/data/provider/firebase_cloud_store_record_provider.dart';
import 'package:body_temperature_note/data/provider/hive_record_provider.dart';
import 'package:body_temperature_note/data/repository/record_repository.dart';
import 'package:body_temperature_note/firebase_options.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/views/home/home_cubit.dart';
import 'package:body_temperature_note/views/utils/app_bloc_observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  const appName = "BodyTemperatureNote";

  //final costTimeForLaunch = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: appName, options: DefaultFirebaseOptions.currentPlatform);

  // init hive & hive_data_provider
  await Hive.initFlutter("RecordDB");
  Hive.registerAdapter(HiveRecordAdapter());
  final box = await Hive.openBox<HiveRecord>("RecordDB");
  final hiveRecordProvider = HiveRecordProvider(box);

  // init fireStore
  final fireStore = FirebaseFirestore.instanceFor(app: Firebase.app(appName));
  final fireStoreRecordProvider = FirebaseCloudStoreRecordProvider(fireStore);

  //0:00:00.100910
  //0:00:00.060453
  //0:00:00.059683
  //print('[Tony] ${costTimeForLaunch.difference(DateTime.now())})');
  BlocOverrides.runZoned(() {
    runApp(MyApp(
      hiveRecordProvider: hiveRecordProvider,
      firebaseCloudStoreRecordProvider: fireStoreRecordProvider,
    ));
  }, blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  final HiveRecordProvider _hiveRecordProvider;
  final FirebaseCloudStoreRecordProvider _firebaseCloudStoreRecordProvider;

  MyApp({
    required HiveRecordProvider hiveRecordProvider,
    required FirebaseCloudStoreRecordProvider firebaseCloudStoreRecordProvider,
  })  : _hiveRecordProvider = hiveRecordProvider,
        _firebaseCloudStoreRecordProvider = firebaseCloudStoreRecordProvider;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<RecordRepository>(
            create: (BuildContext context) => RecordRepository(
                hiveRecordProvider: _hiveRecordProvider,
                firebaseCloudStoreRecordProvider:
                    _firebaseCloudStoreRecordProvider))
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit())
        ],
        child: MaterialApp.router(
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser(),
        ),
      ),
    );
  }
}
