import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_text.dart';

class CustomPopScope extends StatelessWidget {
  const CustomPopScope({
    super.key,
    this.nextRoute,
    required this.child,
  });

  final String? nextRoute;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _handlePop(context, didPop, theme, screenWidth),
      child: child,
    );
  }

  Future<void> _handlePop(
    BuildContext context,
    bool didPop,
    ThemeData theme,
    double screenWidth,
  ) async {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return;
    }

    if (!didPop) {
      if (nextRoute != null) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          nextRoute!,
          (route) => false,
        );
        return;
      }

      final shouldExit = await _showExitDialog(context, theme, screenWidth);
      if (shouldExit ?? false) {
        SystemNavigator.pop();
      }
    }
  }

  Future<bool?> _showExitDialog(BuildContext context, ThemeData theme, double screenWidth) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => _buildExitDialog(ctx, theme, screenWidth),
    );
  }

  Widget _buildExitDialog(BuildContext context, ThemeData theme, double screenWidth) {
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
        width: screenWidth * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ConstText.exitApp,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              ConstText.exitMessage,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: _buildDialogButton(
                    context: context,
                    text: ConstText.cancelExit,
                    isPrimary: false,
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildDialogButton(
                    context: context,
                    text: ConstText.exit,
                    isPrimary: true,
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
  }) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Material(
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              color: isPrimary ? theme.colorScheme.primary : Colors.transparent,
              border: isPrimary ? null : Border.all(color: theme.colorScheme.primary),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isPrimary ? Colors.white : theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
