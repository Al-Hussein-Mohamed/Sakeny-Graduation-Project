import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/core/APIs/api_post.dart';
import 'package:sakeny/core/services/navigation_service.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/post/posts/controllers/post_synchronizer.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'post_state.dart';

enum PostContent { home, favorites, profile }

class PostCubit extends Cubit<PostState> {
  PostCubit({required this.postContent, this.userId}) : super(const PostLoading()) {
    _favoritesSubscription = PostSynchronizer.onFavoriteChanged.listen(_handleFavoriteChange);
    _likesSubscription = PostSynchronizer.onLikeChanged.listen(_handleLikeChange);
    _commentSubscription = PostSynchronizer.onCommentChanged.listen(_handleCommentChange);
    _rateSubscription = PostSynchronizer.onUserRateChanged.listen(_handleRateChange);
    _postSyncSubscription = PostSynchronizer.onPostChanged.listen(_handPostChange);
    _deletedPostSyncSubscription = PostSynchronizer.onPostDeleted.listen(_handleDeletedPostChange);

    switch (postContent) {
      case PostContent.home:
        break;

      case PostContent.favorites:
        loadFavoritesPosts();
        break;

      case PostContent.profile:
        loadProfilePosts();
        break;
    }
  }

  final PostContent postContent;
  final int _pageSize = 15;
  final String? userId;
  int _currentPage = 1;
  bool _loading = false;
  bool _refreshing = false;

  late final StreamSubscription<String> _favoritesSubscription;
  late final StreamSubscription<String> _likesSubscription;
  late final StreamSubscription<String> _commentSubscription;
  late final StreamSubscription<int> _rateSubscription;
  late final StreamSubscription<PostModel> _postSyncSubscription;
  late final StreamSubscription<int> _deletedPostSyncSubscription;

  static PostCubit of(BuildContext context) => context.read<PostCubit>();

  @override
  Future<void> close() {
    _favoritesSubscription.cancel();
    _likesSubscription.cancel();
    _commentSubscription.cancel();
    _rateSubscription.cancel();
    _postSyncSubscription.cancel();
    _deletedPostSyncSubscription.cancel();
    return super.close();
  }

  void _handleFavoriteChange(String postId) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    final int index = curState.posts.indexWhere((post) => post.postId.toString() == postId);

    if (index != -1) {
      final bool? newStatus = PostSynchronizer.getFavoriteStatus(postId);
      if (newStatus != null && curState.posts[index].isFavorite != newStatus) {
        final updatedPosts = List<PostModel>.from(curState.posts);
        updatedPosts[index] = updatedPosts[index].copyWith(isFavorite: newStatus);
        emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));
      }
    }
  }

  void _handleLikeChange(String postId) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    final int index = curState.posts.indexWhere((post) => post.postId.toString() == postId);

    if (index != -1) {
      final bool? newLikeStatus = PostSynchronizer.getLikeStatus(postId);
      final int? newLikeCount = PostSynchronizer.getLikeCount(postId);

      if (newLikeStatus != null && newLikeCount != null) {
        if (curState.posts[index].isLiked != newLikeStatus ||
            curState.posts[index].likesCount != newLikeCount) {
          final updatedPosts = List<PostModel>.from(curState.posts);
          updatedPosts[index] = updatedPosts[index].copyWith(
            isLiked: newLikeStatus,
            likesCount: newLikeCount,
          );
          emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));
        }
      }
    }
  }

  void _handleRateChange(int postId) {
    if (state is! PostLoaded) return;

    if (PostSynchronizer.isUserRateModified(postId) == false) return;

    final curState = state as PostLoaded;
    final List<PostModel> posts = List<PostModel>.from(curState.posts);
    final int index = posts.indexWhere((post) => post.postId == postId);
    final num? newRate = PostSynchronizer.getUserRate(postId);

    if (index == -1) return;
    if (posts[index].unit.visitorRate == newRate) return;

    posts[index] = posts[index].copyWith(unit: posts[index].unit.copyWith(visitorRate: newRate));
    emit(PostLoaded(posts: posts, hasReachedMax: curState.hasReachedMax));
  }

  void _handleCommentChange(String postId) {}

  void _handPostChange(PostModel post) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    final int index = curState.posts.indexWhere((p) => p.postId == post.postId);
    if (index == -1) return;

    final updatedPosts = List<PostModel>.from(curState.posts);
    updatedPosts[index] = post;
    emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));
  }

  void _handleDeletedPostChange(int postId) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    final updatedPosts = curState.posts.where((post) => post.postId != postId).toList();
    emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));
  }

  Future<void> refreshPosts(UserAuthState userState) async {
    if (_refreshing) return;
    _refreshing = true;

    final String? userId =
        userState is GuestUser ? null : (userState as AuthenticatedUser).userModel?.userId;

    _currentPage = 1;
    await loadHomePosts(userId, refresh: true);

    _refreshing = false;
  }

  Future<void> loadHomePosts(String? userId, {bool? refresh}) async {
    if (refresh == null && state is PostLoaded && (state as PostLoaded).hasReachedMax) return;
    if (_loading) return;
    _loading = true;

    try {
      await ApiPost.getPosts(pageCount: _currentPage, pageSize: _pageSize, userId: userId).then(
        (res) {
          res.fold(
            (error) => emit(PostFailure(error: error)),
            (posts) {
              if (posts.isNotEmpty) {
                _currentPage++;
              }

              final List<PostModel> newPosts = [
                ...(state is PostLoaded && refresh == null ? (state as PostLoaded).posts : []),
                ...posts,
              ];

              emit(PostLoaded(posts: newPosts, hasReachedMax: posts.length < _pageSize));
            },
          );
        },
      );
    } catch (e) {
      emit(PostFailure(error: e.toString()));
    }

    _loading = false;
  }

  void loadFavoritesPosts() async {
    if (state is PostLoaded && (state as PostLoaded).hasReachedMax) return;

    if (_loading) return;
    _loading = true;

    await ApiPost.getFavoritesList(pageSize: _pageSize, pageIndex: _currentPage).then((res) {
      res.fold((error) {
        emit(PostFailure(error: error));
      }, (posts) {
        if (posts.isNotEmpty) {
          _currentPage++;
        }

        final List<PostModel> newPosts = [
          ...(state is PostLoaded ? (state as PostLoaded).posts : []),
          ...posts,
        ];

        emit(PostLoaded(posts: newPosts, hasReachedMax: posts.length < _pageSize));
      });
    });

    _loading = false;
  }

  void loadProfilePosts() async {
    if (state is PostLoaded && (state as PostLoaded).hasReachedMax) return;

    if (_loading) return;
    _loading = true;

    await ApiPost.getPostsByUser(userId: userId!, pageSize: _pageSize, pageCount: _currentPage)
        .then((res) {
      res.fold((error) {
        emit(PostFailure(error: error));
      }, (posts) {
        if (posts.isNotEmpty) {
          _currentPage++;
        }

        final List<PostModel> newPosts = [
          ...(state is PostLoaded ? (state as PostLoaded).posts : []),
          ...posts,
        ];

        emit(PostLoaded(posts: newPosts, hasReachedMax: posts.length < _pageSize));
      });
    });

    _loading = false;
  }

  void addLike({required int index}) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    if (curState.posts[index].isLiked) return;

    ApiPost.addLikeToPost(postId: curState.posts[index].postId).then(
      (res) {
        res.fold((error) {
          emit(PostFailure(error: error));
        }, (response) {
          final int newLikeCount = curState.posts[index].likesCount + 1;
          final updatedPosts = List<PostModel>.from(curState.posts);
          updatedPosts[index] =
              updatedPosts[index].copyWith(isLiked: true, likesCount: newLikeCount);
          emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));

          // Synchronize with other instances
          PostSynchronizer.setLikeStatus(
            curState.posts[index].postId.toString(),
            true,
            newLikeCount,
          );
        });
      },
    );
  }

  void removeLike({required int index}) {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    if (!curState.posts[index].isLiked) return;

    ApiPost.removeLikeFromPost(postId: curState.posts[index].postId).then(
      (res) {
        res.fold((error) {
          emit(PostFailure(error: error));
        }, (response) {
          final int newLikeCount = curState.posts[index].likesCount - 1;
          final updatedPosts = List<PostModel>.from(curState.posts);
          updatedPosts[index] =
              updatedPosts[index].copyWith(isLiked: false, likesCount: newLikeCount);
          emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));

          // Synchronize with other instances
          PostSynchronizer.setLikeStatus(
            curState.posts[index].postId.toString(),
            false,
            newLikeCount,
          );
        });
      },
    );
  }

  void addPostToFavorites({required int index}) async {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    if (curState.posts[index].isFavorite) return;

    await ApiPost.addPostToFavorites(postId: curState.posts[index].postId).then((res) {
      res.fold((error) {
        emit(PostFailure(error: error));
      }, (r) {
        final updatedPosts = List<PostModel>.from(curState.posts);
        updatedPosts[index] = updatedPosts[index].copyWith(isFavorite: true);
        emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));

        // Synchronize with other instances
        PostSynchronizer.setFavoriteStatus(
          curState.posts[index].postId.toString(),
          true,
        );
      });
    });
  }

  void removePostFromFavorites({required int index}) async {
    if (state is! PostLoaded) return;

    final curState = state as PostLoaded;
    if (!curState.posts[index].isFavorite) return;

    await ApiPost.removePostFromFavorites(postId: curState.posts[index].postId).then((res) {
      res.fold((error) {
        emit(PostFailure(error: error));
      }, (r) {
        final updatedPosts = List<PostModel>.from(curState.posts);
        updatedPosts[index] = updatedPosts[index].copyWith(isFavorite: false);
        emit(PostLoaded(posts: updatedPosts, hasReachedMax: curState.hasReachedMax));

        // Synchronize with other instances
        PostSynchronizer.setFavoriteStatus(
          curState.posts[index].postId.toString(),
          false,
        );
      });
    });
  }

  void addCommentToPost() {
    // TODO: Implement add comment to post
  }

  void showGuestLoginToast() {
    final context = sl<NavigationService>().navigatorKey.currentContext;
    if (context == null || !context.mounted) return;
    final S lang = S.of(context);
    ToastificationService.showToast(
      context,
      ToastificationType.error,
      lang.toastPleaseLoginTitle,
      lang.toastPleaseLoginMessage,
    );
  }

  void toggleRent({
    required int postId,
    required int unitId,
    required bool nextIsRented,
  }) async {
    if (state is! PostLoaded) return;
    final curState = state as PostLoaded;
    final posts = List<PostModel>.from(curState.posts);
    final index = posts.indexWhere((post) => post.postId == postId);
    if (index == -1) return;

    if (posts[index].unit.isRented == nextIsRented) return;

    EasyLoading.show();
    final res = await ApiPost.editPost(
      postId: postId,
      unitId: unitId,
      isRented: true,
    );

    res.fold(
      (error) => ToastificationService.showGlobalErrorToast(error),
      (r) {
        ToastificationService.showGlobalSuccessToast(null);
        final PostModel syncedPost = posts[index]
            .copyWith(unit: posts[index].unit.copyWith(isRented: nextIsRented, visitorRate: null));
        PostSynchronizer.syncPost(syncedPost);
      },
    );

    EasyLoading.dismiss();
  }

  void deletePost({
    required int postId,
    required int unitId,
  }) async {
    if (state is! PostLoaded) return;

    EasyLoading.show();
    final res = await ApiPost.editPost(
      postId: postId,
      unitId: unitId,
      isDeleted: true,
    );

    res.fold(
      (error) => ToastificationService.showGlobalErrorToast(error),
      (r) {
        ToastificationService.showGlobalSuccessToast(null);
        PostSynchronizer.syncDeletedPost(postId);
      },
    );

    EasyLoading.dismiss();
  }
}
