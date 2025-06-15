import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, required this.onTap, required this.title});

  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.bodyMedium
                : CustomTextTheme.darkTextTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
