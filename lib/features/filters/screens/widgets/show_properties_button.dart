import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';

class ShowPropertiesButton extends StatelessWidget {
  const ShowPropertiesButton({super.key, required this.onTap, required this.title});

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? ConstColors.scaffoldBackgroundDark
              : ConstColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: Theme.of(context).brightness == Brightness.light
                ? ConstColors.scaffoldBackgroundDark
                : ConstColors.scaffoldBackground,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.darkTextTheme.bodyMedium
                : CustomTextTheme.lightTextTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
