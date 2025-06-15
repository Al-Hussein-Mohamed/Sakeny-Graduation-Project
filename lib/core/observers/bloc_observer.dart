import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

// pretty-printer logger
final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 80,
  ),
);

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i('🟢 Created', error: bloc.runtimeType.toString());
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.d('➡️ Event', error: '${bloc.runtimeType} ⇒ $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.i(
      '🔵 State Changed',
      error: '${bloc.runtimeType}: ${change.currentState} → ${change.nextState}',
    );
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // 🔵 Blue circle for updates/transitions
    _logger.i(
      '🔵 Updated',
      error: '${bloc.runtimeType}: ${transition.currentState} → ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.e('💥 Error in ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i('🔴 Closed', error: bloc.runtimeType.toString());
  }
}
