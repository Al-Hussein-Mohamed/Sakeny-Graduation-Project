import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.prefixIcon,
    required this.title,
    required this.onTap,
  });

  final Widget prefixIcon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 45;
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.light
        ? ConstColors.grey
        : ConstColors.onScaffoldBackgroundDark;
    final Color contentColor = theme.brightness == Brightness.light ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(),
          shape: RoundedRectangleBorder(borderRadius: ConstConfig.borderRadius),
          maximumSize: const Size(double.infinity, buttonHeight),
          minimumSize: const Size(double.infinity, buttonHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixIcon,
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(color: contentColor),
            ),
          ],
        ),
      ),
    );
  }
}
