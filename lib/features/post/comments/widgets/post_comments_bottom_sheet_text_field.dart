part of '../screens/post_comments_bottom_sheet.dart';

class PostCommentsBottomSheetTextField extends StatelessWidget {
  const PostCommentsBottomSheetTextField({
    super.key,
    required this.profilePictureURL,
    required this.draggableController,
    required this.scrollController,
  });

  final DraggableScrollableController draggableController;
  final ScrollController scrollController;
  final String? profilePictureURL;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Divider(color: Colors.grey[300], height: 1),
          const SizedBox(height: 12),
          _CommentTextField(
            profilePictureURL: profilePictureURL,
            draggableController: draggableController,
            scrollController: scrollController,
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}

class _CommentTextField extends StatefulWidget {
  const _CommentTextField({
    required this.profilePictureURL,
    required this.draggableController,
    required this.scrollController,
  });

  final DraggableScrollableController draggableController;
  final ScrollController scrollController;

  final String? profilePictureURL;

  @override
  State<_CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<_CommentTextField> with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  double _previousBottomInset = 0.0;
  bool valid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _scrollControllerUp() {
    widget.draggableController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final window = WidgetsBinding.instance.window;
    final bottomInset = window.viewInsets.bottom;

    if (bottomInset > _previousBottomInset) {
      _scrollControllerUp();
    }

    _previousBottomInset = bottomInset;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _formKey.currentState?.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmit(String value) {
    if (value.isEmpty) return;
    final CommentCubit commentCubit = context.read<CommentCubit>();
    commentCubit.addComment(content: _commentController.text).then((value) {
      widget.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
    setState(() => valid = false);
    _commentController.clear();
    PostSynchronizer.incrementCommentsCount(commentCubit.postId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final CommentCubit commentCubit = context.read<CommentCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final Color borderColor = Colors.grey[600]!;

    final Color backgroundColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : ConstColors.onScaffoldBackgroundDark.withValues(alpha: .6);

    const double profilePictureSize = 35;

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            ViewProfilePicture(
              profilePictureURL: widget.profilePictureURL,
              profilePictureSize: profilePictureSize,
            ),
            Expanded(
              child: TextFormField(
                controller: _commentController,
                onChanged: (value) {
                  setState(() {
                    valid = _commentController.text.trim().isNotEmpty;
                  });
                },
                onFieldSubmitted: _onSubmit,
                decoration: InputDecoration(
                  hintText: lang.writeComment,
                  fillColor: Colors.transparent,
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: valid ? CustomColorScheme.getColor(context, CustomColorScheme.text) : null,
              ),
              onPressed: valid
                  ? () {
                      commentCubit.addComment(content: _commentController.text).then((value) {
                        widget.scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      });
                      _commentController.clear();
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
