import 'package:flutter/material.dart';
import 'package:sakeny/core/utils/Bilingual_text/Bilingual_text_theme_extension.dart';

/// A builder widget that automatically applies bilingual text styling to its child tree
class BilingualBuilder extends StatelessWidget {
  const BilingualBuilder({
    super.key,
    required this.child,
    this.enabled = true,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.bilingual,
      ),
      child: child,
    );
  }
}
