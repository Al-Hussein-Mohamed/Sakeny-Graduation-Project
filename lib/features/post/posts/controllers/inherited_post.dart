import 'package:flutter/material.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';

class InheritedPost extends InheritedWidget {
  const InheritedPost({super.key, required this.post, required super.child});

  final PostModel post;

  @override
  bool updateShouldNotify(covariant InheritedPost oldWidget) {
    return post != oldWidget.post;
  }

  static InheritedPost? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPost>();
  }

  static PostModel of(BuildContext context) {
    final InheritedPost? res = maybeOf(context);
    assert(res != null, 'No Inherited Post found the context');
    return res!.post;
  }
}
