import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarPositions extends ChangeNotifier {
  AppBarPositions() {
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(scrollListener)
      ..dispose();
    super.dispose();
  }

  double progress = 0;
  bool isCollapsed = false;
  late final double offsetUpperBound = appBarMaxHeight - appBarMinHeight;

  void scrollListener() {
    final double offset = scrollController.offset.clamp(0, offsetUpperBound);
    final double newProgress = offset / offsetUpperBound;

    if (newProgress == progress) return;
    progress = newProgress;
    isCollapsed = progress == 1;
    notifyListeners();
  }

  bool isAnimated = false;

  void appBarListener(ScrollNotification scrollNotification) async {
    if (scrollNotification is! ScrollEndNotification) return;
    if (progress == 1) return;
    if (progress == 0) return;
    if (isAnimated) return;

    if (progress >= .3) {
      animateTo(offsetUpperBound);
    } else {
      animateTo(0);
    }
  }

  void animateTo(double value) async {
    if (isAnimated) return;
    isAnimated = true;

    while (scrollController.position.isScrollingNotifier.value) {
      await Future.delayed(animationDuration);
    }
    await scrollController.animateTo(
      value,
      duration: appBarAnimationDuration,
      curve: Curves.easeOut,
    );

    isAnimated = false;
  }

  static AppBarPositions of(BuildContext context) => context.read<AppBarPositions>();
  final ScrollController scrollController = ScrollController();
  final animationDuration = const Duration(milliseconds: 5);
  final appBarAnimationDuration = const Duration(milliseconds: 300);

  final double appBarMaxHeight = 180.h;
  final double appBarMinHeight = 70.h;

  double get toolBarHeight => isExpanded ? appBarMaxHeight : appBarMinHeight;

  bool isExpanded = true;
  final double expandedLimit = 15.h;
  final double collapsedLimit = 40.h;
  final double collapsedItemsHeight = 45.h;

  // Drawer icon
  final double drawerIconSize = 24;

  late double drawerIconTop = expandedDrawerIconTop;
  final double expandedDrawerIconTop = 45.h;
  final double collapsedDrawerIconTop = 15.h;

  double get drawerIconTopOffset =>
      expandedDrawerIconTop -
      (expandedDrawerIconTop - collapsedDrawerIconTop) * Curves.easeInOut.transform(progress);

  late double drawerIconHeight = expandedDrawerIconHeight;
  final double expandedDrawerIconHeight = 45.h;
  final double collapsedDrawerIconHeight = 45.h;

  // Search bar
  late double searchBarTop = expandedSearchBarTop;
  final double expandedSearchBarTop = 110.h;
  final double collapsedSearchBarTop = 15.h;

  get searchBarTopOffset =>
      expandedSearchBarTop -
      (expandedSearchBarTop - collapsedSearchBarTop) * Curves.easeOut.transform(progress);

  late double searchBarEnd = expandedSearchBarEnd;
  final double expandedSearchBarEnd = 16;
  late final double collapsedSearchBarEnd = 12 + drawerIconHeight;

  get searchBarEndOffset =>
      expandedSearchBarEnd -
      (expandedSearchBarEnd - collapsedSearchBarEnd) * Curves.easeOutExpo.transform(progress);

  late double searchBarHeight = expandedSearchBarHeight;
  final double expandedSearchBarHeight = 50.h;
  late final double collapsedSearchBarHeight = collapsedItemsHeight;

  get searchBarHeightOffset =>
      expandedSearchBarHeight -
      (expandedSearchBarHeight - collapsedSearchBarHeight) * Curves.easeInOut.transform(progress);

  // Title
  late double titleTop = searchBarTop - 90.h;

  get titleTopOffset => searchBarTopOffset - 90.h;
}
