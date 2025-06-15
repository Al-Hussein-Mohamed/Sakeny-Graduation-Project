import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/features/home/controllers/app_bar_positions.dart';
import 'package:sakeny/features/home/screens/widgets/custom_sliver_app_bar/drawer_icon.dart';
import 'package:sakeny/features/home/screens/widgets/custom_sliver_app_bar/search_bar_widget.dart';
import 'package:sakeny/features/home/screens/widgets/custom_sliver_app_bar/title_widget.dart';

class CustomSliverAppBar extends StatefulWidget {
  const CustomSliverAppBar({super.key});

  @override
  State<CustomSliverAppBar> createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    final AppBarPositions appBarPosition = AppBarPositions.of(context);

    return SliverAppBar(
      expandedHeight: appBarPosition.appBarMaxHeight,
      collapsedHeight: appBarPosition.appBarMinHeight,
      pinned: true,
      automaticallyImplyLeading: false,
      // stretch: true,
      // stretchTriggerOffset: 200,
      // onStretchTrigger: () async {
      //   postCubit.refreshPosts(homeCubit.user);
      // },
      actions: const [SizedBox.shrink()],
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return const _AppBarBackground();
        },
      ),
    );
  }
}

class _AppBarBackground extends StatelessWidget {
  const _AppBarBackground();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Selector<AppBarPositions, bool>(
      selector: (_, appBarPositions) => appBarPositions.isCollapsed,
      builder: (context, value, child) => value
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.9, 1],
                  colors: [
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor,
                    theme.scaffoldBackgroundColor.withAlpha(200),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

class CustomSliverAppBarComponents extends StatelessWidget {
  const CustomSliverAppBarComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SearchBarWidget(),
        TitleWidget(),
        DrawerIcon(),
      ],
    );
  }
}
