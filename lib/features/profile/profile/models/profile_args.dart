import 'package:sakeny/common/models/user_model.dart';

class ProfileArgs {
  ProfileArgs({
    required this.userState,
    required this.userId,
    required this.userName,
    required this.userProfilePictureUrl,
    required this.userRate,
    this.heroTag,
  }) {
    myProfile = userState is AuthenticatedUser &&
        (userState as AuthenticatedUser).userModel?.userId == userId;
  }

  final UserAuthState userState;
  final String userId;
  final String userName;
  final String? userProfilePictureUrl;
  final String? heroTag;
  final num userRate;
  late final bool myProfile;
}
