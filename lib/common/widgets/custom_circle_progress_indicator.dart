import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';

class CustomCircleProgressIndicator extends StatelessWidget {
  const CustomCircleProgressIndicator({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    return Center(
      child: CircularProgressIndicator(
        color: color ?? colors.text,
      ),
    );
  }
}
