import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/generated/l10n.dart';

class ShowYNDialog extends StatelessWidget {
  const ShowYNDialog({
    super.key,
    required this.title,
    required this.action,
    this.actionColor,
  });

  final String title;
  final String action;
  final Color? actionColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      content: SizedBox(
        width: screenWidth * 0.99,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: _buildDialogButton(
                    context: context,
                    text: lang.cancel,
                    isPrimary: false,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDialogButton(
                    context: context,
                    text: action,
                    isPrimary: true,
                    backgroundColor: actionColor,
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton({
    required BuildContext context,
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    final isPrimaryBackground = theme.brightness == Brightness.light
        ? theme.colorScheme.primary
        : ConstColors.onScaffoldBackgroundDark;

    return Material(
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isPrimary ? isPrimaryBackground : theme.scaffoldBackgroundColor),
            border: isPrimary
                ? null
                : Border.all(color: CustomColorScheme.getColor(context, CustomColorScheme.text)),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: isPrimary
                ? theme.textTheme.bodyLarge?.copyWith(color: Colors.white)
                : theme.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
