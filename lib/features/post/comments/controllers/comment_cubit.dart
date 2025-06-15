import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/APIs/api_post.dart';
import 'package:sakeny/features/post/comments/models/comment_model.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({required this.postId, required this.user, required this.commentsCount})
      : super(const CommentLoading()) {
    loadComments();
  }

  late final int postId;
  late UserModel? user;
  final int pageSize = 15;
  int commentsCount;
  int pageCount = 1;
  bool _loading = false;

  Future<void> addComment({required String content}) async {
    if (content.isEmpty) return;
    if (state is! CommentLoaded) return;

    if (_loading) return;
    _loading = true;

    EasyLoading.show();

    await ApiPost.addComment(postId: postId, content: content).then((res) {
      if (user == null) return;
      if (state is! CommentLoaded) return;
      final curState = state as CommentLoaded;
      res.fold(
        (error) {},
        (r) async {
          final List<CommentModel> newComments = [
            CommentModel(
              userProfilePictureURL: user!.profilePictureURL,
              userId: user!.userId,
              userName: user!.fullName,
              commentId: 1010101,
              content: content,
              date: DateTime.now(),
              userRate: 0,
            ),
            ...curState.comments,
          ];
          emit(CommentLoaded(comments: newComments, hasReachedMax: curState.hasReachedMax));
        },
      );
    });

    EasyLoading.dismiss();
    _loading = false;
  }

  Future<void> loadComments() async {
    if (state is CommentLoaded && (state as CommentLoaded).hasReachedMax) return;

    if (_loading) return;
    _loading = true;

    await ApiPost.getAllComments(postId: postId, pageCount: pageCount, pageSize: pageSize)
        .then((res) {
      res.fold(
        (error) => emit(CommentFailure(error: error)),
        (comments) {
          if (comments.isNotEmpty) {
            pageCount++;
          }

          final List<CommentModel> newComments = [
            ...(state is CommentLoaded ? (state as CommentLoaded).comments : []),
            ...comments,
          ];
          emit(CommentLoaded(comments: newComments, hasReachedMax: comments.length < pageSize));
        },
      );
    });

    _loading = false;
  }
}
