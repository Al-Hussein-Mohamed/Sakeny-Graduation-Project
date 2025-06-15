part of '../screens/post_comments_bottom_sheet.dart';

class _CommentSheetHeader extends StatefulWidget {
  const _CommentSheetHeader({
    required this.controller,
  });

  final DraggableScrollableController controller;

  @override
  State<_CommentSheetHeader> createState() => _CommentSheetHeaderState();
}

class _CommentSheetHeaderState extends State<_CommentSheetHeader> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onSheetSizeChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onSheetSizeChanged);
    super.dispose();
  }

  void _onSheetSizeChanged() {
    final bool newExpandedState = widget.controller.size >= 0.93;
    if (newExpandedState == isExpanded) return;
    setState(() => isExpanded = newExpandedState);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final S lang = S.of(context);

    const double appBarHeight = 88;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverHeaderDelegate(
        minHeight: appBarHeight,
        maxHeight: appBarHeight,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: appBarHeight,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(isExpanded ? 0 : 30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isExpanded ? Colors.transparent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding),
                child: Row(
                  children: [
                    Text(
                      lang.comments,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: CustomColorScheme.getColor(
                          context,
                          CustomColorScheme.text,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey[300], height: 1),
            ],
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
