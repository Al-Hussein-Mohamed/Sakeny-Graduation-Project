class ReportModel {
  ReportModel({
    required this.postId,
    required this.problemType,
    required this.description,
  });

  final int postId;
  final int problemType;
  final String? description;

  Map<String, dynamic> toJson() {
    return {
      "postId": postId,
      "typeOfProblem": problemType,
      "description": description,
    };
  }
}
