import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/features/home/controllers/app_bar_positions.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/maps/map_show_units/models/map_show_units_args.dart';
import 'package:sakeny/generated/l10n.dart';

// ignore_for_file: prefer_const_constructors_in_immutables

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  void onSearchBarTap(BuildContext context) {
    HomeCubit.of(context).scrollOnSearchTap();
  }

  void _search(BuildContext context) {
    final HomeCubit homeCubit = HomeCubit.of(context);
    if (homeCubit.searchController.text.isEmpty) return;

    Navigator.pushNamed(
      context,
      PageRouteNames.mapShowUnits,
      arguments: MapShowUnitsArgs(
        searchQuery: homeCubit.searchController.text,
      ),
    );
  }

  void _onFilterIconTap(BuildContext context) {
    Navigator.pushNamed(context, PageRouteNames.filters);
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = HomeCubit.of(context);
    final S lang = S.of(context);
    final theme = Theme.of(context);

    final AppBarPositions appBarPosition = AppBarPositions.of(context);

    return Selector<AppBarPositions, (double, double, double)>(
        selector: (_, appBarPositions) => (
              appBarPositions.searchBarTopOffset,
              appBarPositions.searchBarEndOffset,
              appBarPositions.searchBarHeightOffset,
            ),
        builder: (context, data, _) {
          final double searchBarTop = data.$1;
          final double searchBarEnd = data.$2;
          final double searchBarHeight = data.$3;

          return AnimatedPositionedDirectional(
            duration: appBarPosition.animationDuration,
            top: searchBarTop,
            end: searchBarEnd,
            start: 16,
            child: Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(10.r),
              color: theme.colorScheme.onSurface,
              child: SizedBox(
                height: searchBarHeight,
                // width: appBarPosition.searchBarWidth,
                child: Center(
                  child: TextField(
                    controller: homeCubit.searchController,
                    onTap: () => onSearchBarTap(context),
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _search(context),
                    decoration: InputDecoration(
                      hintText: lang.searchHint,
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: CustomColorScheme.getColor(context, CustomColorScheme.text),
                      ),
                      prefixIcon: GestureDetector(
                        onTap: () => _search(context),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            ConstImages.searchLogo,
                            colorFilter: ColorFilter.mode(
                              CustomColorScheme.getColor(context, CustomColorScheme.text),
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () => _onFilterIconTap(context),
                        child: Container(
                          margin: const EdgeInsetsDirectional.only(
                            end: 6.5,
                            start: 1.5,
                            top: 5.5,
                            bottom: 5.5,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CustomColorScheme.getColor(
                                context, CustomColorScheme.filterSearchIcon),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            ConstImages.searchSettings,
                            width: ConstConfig.smallIconSize,
                            height: ConstConfig.smallIconSize,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent, width: 2.0),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: ConstColors.lightWrongInputField, width: 2.0),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: ConstColors.lightWrongInputField, width: 2.0),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
