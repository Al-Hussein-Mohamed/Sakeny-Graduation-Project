import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';

class RealEstateTypeSelector extends StatelessWidget {
  const RealEstateTypeSelector({
    super.key,
    required this.title,
    required this.iconPath,
    this.onTap,
  });

  final String title;
  final String iconPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 20, bottom: 5),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: SvgPicture.asset(
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
          title: Text(
            title,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.titleSmall
                : CustomTextTheme.darkTextTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}
