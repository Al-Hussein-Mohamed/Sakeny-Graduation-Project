import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/common/widgets/app_logo.dart';
import 'package:sakeny/features/home/controllers/app_bar_positions.dart';
import 'package:sakeny/generated/l10n.dart';

// ignore_for_file: prefer_const_constructors_in_immutables

class TitleWidget extends StatelessWidget {
  TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AppBarPositions appBarPosition = AppBarPositions.of(context);
    final S lang = S.of(context);
    final theme = Theme.of(context);

    return Selector<AppBarPositions, double>(
      selector: (_, appBarPositions) => appBarPositions.titleTopOffset,
      builder: (context, titleTopOffset, _) => AnimatedPositionedDirectional(
        duration: appBarPosition.animationDuration,
        top: titleTopOffset,
        start: 16,
        child: SizedBox(
          height: 90.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: lang.homeTitle1, style: theme.textTheme.titleLarge),
                    // ignore: prefer_const_constructors
                    WidgetSpan(
                      // ignore: prefer_const_constructors
                      child: AppLogo(logoSize: 50),
                    ),
                  ],
                ),
              ),
              Text(lang.homeTitle2, style: theme.textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
