import 'package:flutter/widgets.dart';

class AppLifecycleTracker with WidgetsBindingObserver {

  AppLifecycleTracker({this.onReturnFromBackground}) {
    WidgetsBinding.instance.addObserver(this);
  }
  AppLifecycleState? _lastState;
  final VoidCallback? onReturnFromBackground;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isReturningFromBackground(_lastState, state)) {
      onReturnFromBackground?.call();
    }
    _lastState = state;
  }

  bool _isReturningFromBackground(AppLifecycleState? previous, AppLifecycleState current) {
    return current == AppLifecycleState.resumed &&
        (previous == AppLifecycleState.paused ||
            previous == AppLifecycleState.inactive);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}