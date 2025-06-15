import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";
import "package:provider/provider.dart";
import "package:sakeny/core/constants/const_config.dart";
import "package:sakeny/core/constants/const_images.dart";
import "package:sakeny/core/theme/widget_themes/custom_color_scheme.dart";
import "package:sakeny/features/home/controllers/app_bar_positions.dart";
import 'package:sakeny/features/home/controllers/home_cubit.dart';

// ignore_for_file: prefer_const_constructors_in_immutables

class DrawerIcon extends StatelessWidget {
  DrawerIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final AppBarPositions appBarPositions = AppBarPositions.of(context);

    return Selector<AppBarPositions, double>(
      selector: (_, appBarPositions) => (appBarPositions.drawerIconTopOffset),
      builder: (context, drawerIconTopOffset, _) {
        return AnimatedPositionedDirectional(
          duration: appBarPositions.animationDuration,
          top: drawerIconTopOffset,
          end: 0,
          child: Hero(
            tag: ConstConfig.drawerIconTag,
            child: Material(
              elevation: ConstConfig.elevation,
              color: CustomColorScheme.getColor(context, CustomColorScheme.drawerIcon),
              borderRadius: const BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                bottomStart: Radius.circular(10),
              ),
              child: InkWell(
                onTap: () => homeCubit.scaffoldKey.currentState?.openEndDrawer(),
                child: Container(
                  width: appBarPositions.drawerIconHeight,
                  height: appBarPositions.drawerIconHeight,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: SvgPicture.asset(
                    ConstImages.drawerIcon,
                    width: 40.r,
                    height: 40.r,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
