import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.title,
    required this.onTap,
  });
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.light
        ? ConstColors.grey
        : ConstColors.onScaffoldBackgroundDark;
    final Color contentColor =
        theme.brightness == Brightness.light ? Colors.black : Colors.white;
    const double buttonHeight = 45;

    return TextButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(),
        shape: RoundedRectangleBorder(borderRadius: ConstConfig.borderRadius),
        maximumSize: const Size(double.infinity, buttonHeight),
        minimumSize: const Size(double.infinity, buttonHeight),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(color: contentColor),
      ),
    );
  }
}
