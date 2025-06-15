import 'package:flutter/material.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';

class InheritedUnit extends InheritedWidget {
  const InheritedUnit({super.key, required super.child, required this.unit, required this.post});

  final PostModel post;
  final UnitModel unit;

  @override
  bool updateShouldNotify(InheritedUnit oldWidget) {
    return unit != oldWidget.unit;
  }

  static InheritedUnit? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUnit>();
  }

  static UnitModel of(BuildContext context) {
    final InheritedUnit? res = maybeOf(context);
    assert(res != null, 'No Inherited Unit found the context');
    return res!.unit;
  }

  static PostModel postOf(BuildContext context) {
    final InheritedUnit? res = maybeOf(context);
    assert(res != null, 'No Inherited Unit found the context');
    return res!.post;
  }
}
