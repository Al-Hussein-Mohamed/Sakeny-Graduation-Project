import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, required this.logoSize});

  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        SvgPicture.asset(
          ConstImages.logoBaseSvg,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.fitHeight,
          key: const ValueKey(ConstImages.logoBaseSvg),
        ),
        SvgPicture.asset(
          ConstImages.logoBorderSvg,
          width: logoSize,
          height: logoSize,
          fit: BoxFit.fitHeight,
          key: const ValueKey(ConstImages.logoBorderSvg),
          colorFilter: ColorFilter.mode(
            AppColors.of(context).text,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
