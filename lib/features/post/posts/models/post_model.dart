import 'package:equatable/equatable.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';

class PostModel extends Equatable {
  const PostModel({
    required this.postId,
    required this.title,
    required this.date,
    required this.likesCount,
    required this.commentsCount,
    required this.isLiked,
    required this.isFavorite,
    required this.unit,
    required this.userId,
    required this.userName,
    required this.userProfilePicUrl,
    required this.userRate,
    required this.userRateCount,
  });

  // post
  final int postId;
  final String title;
  final DateTime date;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isFavorite;

  // unit
  final UnitModel unit;

  // user
  final String userId;
  final String userName;
  final String? userProfilePicUrl;
  final num userRate;
  final int userRateCount;

  // ignore: sort_constructors_first
  factory PostModel.fromJson(Map<String, dynamic> json) {
    // ignore: prefer_final_locals
    Map<String, dynamic> unitJson = json['unit'] as Map<String, dynamic>;
    unitJson['date'] = DateTime.parse(json['createdAt'] as String);
    unitJson[KUnitJsonKeys.isFavorite] = json['isFavourite'] as bool;
    return PostModel(
      postId: json['postId'] as int,
      title: json['title'] as String,
      date: DateTime.parse(json['createdAt'] as String),
      likesCount: json['likesCount'] as int,
      commentsCount: json['commentsCount'] as int,
      isLiked: json['isLiked'] as bool,
      isFavorite: json['isFavourite'] as bool,
      unit: UnitModel.fromJson(unitJson),
      userId: json['ownerId'] as String,
      userName: json['owner'] as String,
      userProfilePicUrl: json['ownerPicture'] as String?,
      userRate: json['userRate'] as num,
      userRateCount: json['userCountRate'] as int,
    );
  }

  @override
  List<Object?> get props => [
        postId,
        title,
        date,
        likesCount,
        commentsCount,
        isLiked,
        isFavorite,
        unit,
        userId,
        userName,
        userProfilePicUrl,
        userRate,
        userRateCount,
      ];

  PostModel copyWith({
    int? postId,
    String? title,
    DateTime? date,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isFavorite,
    UnitModel? unit,
    String? userId,
    String? userName,
    String? userProfilePicUrl,
    num? userRate,
    int? userRateCount,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      title: title ?? this.title,
      date: date ?? this.date,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isFavorite: isFavorite ?? this.isFavorite,
      unit: unit ?? this.unit,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfilePicUrl: userProfilePicUrl ?? this.userProfilePicUrl,
      userRate: userRate ?? this.userRate,
      userRateCount: userRateCount ?? this.userRateCount,
    );
  }
}
