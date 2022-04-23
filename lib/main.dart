import 'package:body_temperature_note/firebase_options.dart';
import 'package:body_temperature_note/route/app_router.gr.dart';
import 'package:body_temperature_note/views/home/home_cubit.dart';
import 'package:body_temperature_note/views/utils/app_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  BlocOverrides.runZoned(() {
    runApp(MyApp());
  }, blocObserver: AppBlocObserver());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit())
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
