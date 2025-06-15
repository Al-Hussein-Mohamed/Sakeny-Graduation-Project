

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';

class PropertyButton extends StatelessWidget {
  const PropertyButton({
    super.key,
    required this.iconPath,
    required this.title,
  });

  final String iconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              BlendMode.srcIn,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: Theme.of(context).brightness == Brightness.light
                  ? CustomTextTheme.lightTextTheme.bodySmall
                  : CustomTextTheme.darkTextTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
