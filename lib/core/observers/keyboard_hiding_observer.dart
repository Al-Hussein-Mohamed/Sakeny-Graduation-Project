import 'package:flutter/material.dart';

class KeyboardHidingObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didStartUserGesture(route, previousRoute);
  }
}
