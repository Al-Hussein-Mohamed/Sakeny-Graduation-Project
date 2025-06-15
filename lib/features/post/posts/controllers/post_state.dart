part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();
}

final class PostLoading extends PostState {
  const PostLoading();

  @override
  List<Object?> get props => [];
}

final class PostLoaded extends PostState {
  const PostLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  final List<PostModel> posts;
  final bool hasReachedMax;

  @override
  List<Object?> get props => [posts, hasReachedMax];
}

final class PostFailure extends PostState {
  const PostFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
