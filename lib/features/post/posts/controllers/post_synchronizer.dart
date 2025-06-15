import 'dart:async';

import 'package:sakeny/features/post/posts/models/post_model.dart';

class PostSynchronizer {
  PostSynchronizer._();

  // ----------------------> Sync Posts <----------------------
  static final StreamController<PostModel> _postStreamController =
      StreamController<PostModel>.broadcast();

  static Stream<PostModel> get onPostChanged => _postStreamController.stream;

  static void syncPost(PostModel post) {
    _postStreamController.add(post);
  }

  // ----------------------> Sync deleted Posts <----------------------
  static final StreamController<int> _deletedPostStreamController =
      StreamController<int>.broadcast();

  static Stream<int> get onPostDeleted => _deletedPostStreamController.stream;

  static void syncDeletedPost(int postId) {
    _deletedPostStreamController.add(postId);
  }

  // ----------------------> Sync Visitor Rate <----------------------
  static final StreamController<int> _userRatesController = StreamController<int>.broadcast();

  static Stream<int> get onUserRateChanged => _userRatesController.stream;

  static final Map<int, num> _userRates = {};

  static void setUserRate(int postId, num rate) {
    // if (_userRates[postId] != rate) {
    //   _userRates[postId] = rate;
    //   _userRatesController.add(postId);
    // }
  }

  static bool isUserRateModified(int postId) => _userRates.containsKey(postId);

  static num? getUserRate(int postId) => _userRates[postId];

  // -------------------------------------------------------------
  static final Map<String, bool> _favorites = {};
  static final Map<String, bool> _likes = {};
  static final Map<String, int> _likesCount = {};
  static final Map<String, int> _commentsCount = {};

  static final StreamController<String> _favoritesController = StreamController<String>.broadcast();
  static final StreamController<String> _likesController = StreamController<String>.broadcast();
  static final StreamController<String> _commentsController = StreamController<String>.broadcast();

  static Stream<String> get onFavoriteChanged => _favoritesController.stream;

  static Stream<String> get onLikeChanged => _likesController.stream;

  static Stream<String> get onCommentChanged => _commentsController.stream;

  static void setFavoriteStatus(String postId, bool isFavorite) {
    if (_favorites[postId] != isFavorite) {
      _favorites[postId] = isFavorite;
      _favoritesController.add(postId);
    }
  }

  static void setLikeStatus(String postId, bool isLiked, int count) {
    bool changed = false;

    if (_likes[postId] != isLiked) {
      _likes[postId] = isLiked;
      changed = true;
    }

    if (_likesCount[postId] != count) {
      _likesCount[postId] = count;
      changed = true;
    }

    if (changed) {
      _likesController.add(postId);
    }
  }

  static void setCommentsCount(String postId, int count) {
    if (_commentsCount[postId] != count) {
      _commentsCount[postId] = count;
      _commentsController.add(postId);
    }
  }

  static void incrementCommentsCount(String postId) {
    if (_commentsCount.containsKey(postId)) {
      _commentsCount[postId] = (_commentsCount[postId] ?? 0) + 1;
    } else {
      _commentsCount[postId] = 1;
    }
    _commentsController.add(postId);
  }

  static bool? getFavoriteStatus(String postId) => _favorites[postId];

  static bool? getLikeStatus(String postId) => _likes[postId];

  static int? getLikeCount(String postId) => _likesCount[postId];

  static int? getCommentsCount(String postId) => _commentsCount[postId];

  static bool isFavoriteModified(String postId) => _favorites.containsKey(postId);

  static bool isLikeModified(String postId) => _likes.containsKey(postId);

  static bool isCommentModified(String postId) => _commentsCount.containsKey(postId);

  static void dispose() {
    _favoritesController.close();
    _likesController.close();
    _commentsController.close();
  }
}

class RentPostSyncModel {
  RentPostSyncModel({
    required this.postId,
    required this.isRented,
  });

  final int postId;
  final bool isRented;
}
