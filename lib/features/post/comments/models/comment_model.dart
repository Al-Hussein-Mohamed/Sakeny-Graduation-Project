import 'package:equatable/equatable.dart';

class CommentModel extends Equatable {
  const CommentModel({
    required this.userProfilePictureURL,
    required this.userId,
    required this.userName,
    required this.commentId,
    required this.content,
    required this.date,
    required this.userRate,
  });

  final String? userProfilePictureURL;
  final String userId;
  final String userName;
  final String content;

  final int commentId;

  final DateTime date;

  final num userRate;

  /// Returns the date in Egypt time zone (UTC+2)
  DateTime get egyptTime => date.toUtc().add(const Duration(hours: 3));

  /// Returns a formatted string of the Egypt time
  String get formattedDate => egyptTime.toString();

  @override
  List<Object?> get props => [
        userProfilePictureURL,
        userId,
        userName,
        content,
        commentId,
        date,
        userRate,
      ];

  Map<String, dynamic> toJson() {
    return {
      'userImage': userProfilePictureURL,
      'userId': userId,
      'name': userName,
      'content': content,
      'commentId': commentId,
      'createdAt': date.toString(),
    };
  }

  // ignore: sort_constructors_first
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userProfilePictureURL: json['userImage'],
      userId: json['userId'] as String,
      userName: json['name'] as String,
      content: json['content'] as String,
      commentId: json['commentId'] as int,
      date: DateTime.parse(json['createdAt']),
      userRate: json['userRate'] != null ? json['userRate'] as num : 0,
    );
  }
}
