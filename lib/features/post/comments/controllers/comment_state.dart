part of 'comment_cubit.dart';

sealed class CommentState extends Equatable {
  const CommentState();
}

final class CommentLoading extends CommentState {
  const CommentLoading();

  @override
  List<Object?> get props => [];
}

final class CommentLoaded extends CommentState {
  const CommentLoaded({
    required this.comments,
    required this.hasReachedMax,
  });

  final List<CommentModel> comments;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [comments, hasReachedMax];
}

final class CommentFailure extends CommentState {
  const CommentFailure({
    required this.error,
  });

  final String error;

  @override
  List<Object?> get props => [error];
}
