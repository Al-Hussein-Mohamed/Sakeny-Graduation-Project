import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';

class ValueButton extends StatelessWidget {
  const ValueButton({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            title,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.bodySmall
                : CustomTextTheme.darkTextTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
