import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/utils/helpers/quick_bouncing_scrool_physics.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/post/comments/controllers/comment_cubit.dart';
import 'package:sakeny/features/post/comments/models/comment_model.dart';
import 'package:sakeny/features/post/posts/controllers/post_synchronizer.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:shimmer/shimmer.dart';

part '../widgets/comment_item.dart';
part '../widgets/post_comments_bottom_sheet_header.dart';
part '../widgets/post_comments_bottom_sheet_text_field.dart';

class PostCommentsBottomSheet extends StatefulWidget {
  const PostCommentsBottomSheet({super.key, required this.profilePictureURL});

  final String? profilePictureURL;

  @override
  State<PostCommentsBottomSheet> createState() => _PostCommentsBottomSheetState();
}

class _PostCommentsBottomSheetState extends State<PostCommentsBottomSheet> {
  late DraggableScrollableController _draggableScrollController;

  @override
  void initState() {
    super.initState();
    _draggableScrollController = DraggableScrollableController();
  }

  @override
  void dispose() {
    _draggableScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double initialHeight = 0.7;
    const double minHeight = 0.5;
    const double maxHeight = 1;

    return _Comments(
      initialHeight: initialHeight,
      minHeight: minHeight,
      maxHeight: maxHeight,
      profilePictureURL: widget.profilePictureURL,
      draggableScrollController: _draggableScrollController,
    );
  }
}

class _Comments extends StatelessWidget {
  const _Comments({
    required this.initialHeight,
    required this.minHeight,
    required this.maxHeight,
    required this.draggableScrollController,
    required this.profilePictureURL,
  });

  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final String? profilePictureURL;
  final DraggableScrollableController draggableScrollController;

  @override
  Widget build(BuildContext context) {
    final CommentCubit commentCubit = context.read<CommentCubit>();
    final ThemeData theme = Theme.of(context);
    return DraggableScrollableSheet(
      controller: draggableScrollController,
      initialChildSize: initialHeight,
      minChildSize: minHeight,
      maxChildSize: maxHeight,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            image: theme.brightness == Brightness.dark
                ? const DecorationImage(
                    image: AssetImage(ConstImages.backgroundDark),
                    fit: BoxFit.cover,
                  )
                : null,
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: NotificationListener(
            onNotification: (ScrollNotification scrollNotification) {
              if (scrollNotification.metrics.pixels >
                  scrollNotification.metrics.maxScrollExtent - 400) {
                commentCubit.loadComments();
              }
              return false;
            },
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const QuickBouncingScrollPhysics(),
                    slivers: [
                      _CommentSheetHeader(controller: draggableScrollController),
                      SliverPadding(
                        padding: EdgeInsets.only(
                          left: 16.0,
                          right: 16,
                          top: 16,
                          bottom: 16 + MediaQuery.of(context).padding.bottom,
                        ),
                        sliver: BlocBuilder<CommentCubit, CommentState>(
                          builder: (context, state) {
                            switch (state) {
                              case CommentLoading():
                                return SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: 5,
                                    (context, index) => const CommentItemShimmer(),
                                  ),
                                );

                              case CommentLoaded():
                                return _CommentsLoaded(
                                  comments: state.comments,
                                  hasReachedMax: state.hasReachedMax,
                                );

                              case CommentFailure():
                                return SliverToBoxAdapter(
                                  child: Center(
                                    child: Text(state.error),
                                  ),
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                if (commentCubit.user != null)
                  PostCommentsBottomSheetTextField(
                    profilePictureURL: profilePictureURL,
                    draggableController: draggableScrollController,
                    scrollController: scrollController,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CommentsLoaded extends StatelessWidget {
  const _CommentsLoaded({
    required this.comments,
    required this.hasReachedMax,
  });

  final List<CommentModel> comments;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return comments.isEmpty
        ? const _EmptyCommentsBody()
        : SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: comments.length + 1,
              (context, index) {
                if (index < comments.length) {
                  return CommentItem(comment: comments[index]);
                }

                return AnimatedCrossFade(
                  duration: const Duration(milliseconds: 500),
                  firstChild: const CommentItemShimmer(),
                  secondChild: const SizedBox.shrink(),
                  crossFadeState:
                      hasReachedMax ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                );
              },
            ),
          );
  }
}

class _EmptyCommentsBody extends StatelessWidget {
  const _EmptyCommentsBody();

  @override
  Widget build(BuildContext context) {
    final double iconSize = 100;
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: ConstConfig.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              SvgPicture.asset(
                ConstImages.postEmptyComments,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(
                  CustomColorScheme.getColor(context, CustomColorScheme.text),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                lang.beTheFirstToComment,
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
