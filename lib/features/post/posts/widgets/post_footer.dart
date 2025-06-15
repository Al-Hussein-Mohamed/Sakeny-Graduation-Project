part of '../screens/post_widget.dart';

class _PostFooter extends StatelessWidget {
  const _PostFooter({
    required this.postId,
    required this.unitId,
    required this.isEditing,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.idx,
    required this.isRented,
  });

  final int postId;
  final int unitId;
  final bool isEditing;
  final int idx;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isRented;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _LikeButton(
            idx: idx,
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          _CommentButton(
            idx: idx,
            commentCount: commentCount,
          ),
        ],
      ),
      secondChild: EditPostFooter(
        postId: postId,
        unitId: unitId,
        isRented: isRented,
      ),
      crossFadeState: isEditing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _LikeButton extends StatefulWidget {
  const _LikeButton({
    required this.isLiked,
    required this.likeCount,
    required this.idx,
  });

  final int idx;
  final int likeCount;
  final bool isLiked;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton> {
  late bool isLiked = widget.isLiked;
  late int likeCount = widget.likeCount;
  StreamSubscription? _likeSubscription;

  @override
  void initState() {
    super.initState();

    // Listen for external like changes
    final PostCubit postCubit = context.read<PostCubit>();
    if (postCubit.state is PostLoaded) {
      final String postId = (postCubit.state as PostLoaded).posts[widget.idx].postId.toString();
      _likeSubscription = PostSynchronizer.onLikeChanged
          .where((changedPostId) => changedPostId == postId)
          .listen(_onLikeExternalChange);
    }
  }

  @override
  void dispose() {
    _likeSubscription?.cancel();
    super.dispose();
  }

  void _onLikeExternalChange(String postId) {
    final bool? newLikeStatus = PostSynchronizer.getLikeStatus(postId);
    final int? newLikeCount = PostSynchronizer.getLikeCount(postId);

    if (newLikeStatus != null && newLikeCount != null) {
      if (isLiked != newLikeStatus || likeCount != newLikeCount) {
        setState(() {
          isLiked = newLikeStatus;
          likeCount = newLikeCount;
        });
      }
    }
  }

  void _toggleLike(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final PostCubit postCubit = context.read<PostCubit>();

    if (homeCubit.user is GuestUser) {
      postCubit.showGuestLoginToast();
      return;
    }

    if (isLiked) {
      postCubit.removeLike(index: widget.idx);
    } else {
      postCubit.addLike(index: widget.idx);
    }
    setState(() {
      if (isLiked) {
        likeCount--;
        isLiked = false;
      } else {
        likeCount++;
        isLiked = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleLike(context),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ConstImages.postLike,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isLiked ? Colors.blue : getColor(context, ConstColors.primaryColor, Colors.white),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                likeCount > 0 ? "${lang.like} ($likeCount)" : lang.like,
                style: theme.textTheme.bodySmall?.copyWith(color: isLiked ? Colors.blue : null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentButton extends StatefulWidget {
  const _CommentButton({required this.commentCount, required this.idx});

  final int idx;
  final int commentCount;

  @override
  State<_CommentButton> createState() => _CommentButtonState();
}

class _CommentButtonState extends State<_CommentButton> {
  late int commentCount = widget.commentCount;
  StreamSubscription? _commentSubscription;

  @override
  void initState() {
    super.initState();
    final PostCubit postCubit = context.read<PostCubit>();
    if (postCubit.state is PostLoaded) {
      final String postId = (postCubit.state as PostLoaded).posts[widget.idx].postId.toString();
      _commentSubscription = PostSynchronizer.onCommentChanged
          .where((changedPostId) => changedPostId == postId)
          .listen(_onCommentExternalChange);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _commentSubscription?.cancel();
  }

  void _onCommentExternalChange(String postId) {
    final int? newCommentCount = PostSynchronizer.getCommentsCount(postId);
    if (newCommentCount != null && newCommentCount != commentCount) {
      setState(() {
        commentCount = newCommentCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: () => _showCommentsBottomSheet(context),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                ConstImages.postComment,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  getColor(context, ConstColors.primaryColor, Colors.white),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                commentCount > 0 ? "${lang.comments} ($commentCount)" : lang.comments,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();
    final String? userProfilePictureURL = (homeCubit.user is GuestUser)
        ? null
        : (homeCubit.user as AuthenticatedUser).userModel?.profilePictureURL;
    final PostCubit postCubit = context.read<PostCubit>();
    final int postId = (postCubit.state as PostLoaded).posts[widget.idx].postId;
    final UserModel? user =
        (homeCubit.user is GuestUser) ? null : (homeCubit.user as AuthenticatedUser).userModel;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CommentCubit(postId: postId, commentsCount: widget.commentCount, user: user),
            ),
            BlocProvider.value(value: homeCubit),
          ],
          child: PostCommentsBottomSheet(profilePictureURL: userProfilePictureURL),
        );
      },
    );
  }
}
