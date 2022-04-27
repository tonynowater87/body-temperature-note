import 'package:body_temperature_note/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  final _logger = getIt<Logger>();

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('BlocObserver onCreate ==> $bloc');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i('BlocObserver onClose ==> $bloc');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.i('BlocObserver onError ==> $bloc $error $stackTrace');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.i('BlocObserver onTransition ==> $bloc $transition');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.i('BlocObserver onChange ==> $bloc $change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.i('BlocObserver onEvent ==> $bloc $event');
  }
}
