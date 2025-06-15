part of '../map_show_units_screen.dart';

class _DraggableUnitsSheet extends StatelessWidget {
  const _DraggableUnitsSheet({required this.posts});

  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);
    final ThemeData theme = Theme.of(context);

    return DraggableScrollableSheet(
      controller: mapShowUnitsCubit.sheetScrollController,
      initialChildSize: MapShowUnitsConfig.initialChildSize,
      minChildSize: MapShowUnitsConfig.minChildSize,
      maxChildSize: MapShowUnitsConfig.maxChildSize,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                const _SheetHeader(),
                _UnitsListView(posts: posts),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _UnitsListView extends StatelessWidget {
  const _UnitsListView({required this.posts});

  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    final MapShowUnitsCubit mapShowUnitsCubit = MapShowUnitsCubit.of(context);

    return SliverFillRemaining(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: mapShowUnitsCubit.unitsScrollController,
        itemCount: posts.length,
        itemBuilder: (context, index) => MapUnitItem(index: index, post: posts[index]),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const double headerHeight = 35;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        minHeight: headerHeight,
        maxHeight: headerHeight,
        child: Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          child: Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  _SliverHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return oldDelegate.maxHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.child != child;
  }
}
