import 'dart:ui';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sakeny/core/constants/const_images.dart';

class SignInCardModel {
  SignInCardModel({
    required this.image,
    required this.backgroundColor,
    required this.onTap,
  });

  final String image;
  final Color backgroundColor;
  final void Function()? onTap;

  SignInCardModel copyWith({
    String? image,
    Color? backgroundColor,
    void Function()? onTap,
  }) {
    return SignInCardModel(
      image: image ?? this.image,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      onTap: onTap ?? this.onTap,
    );
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn();

List<SignInCardModel> signInCards = [
  SignInCardModel(
    image: ConstImages.googleIcon,
    backgroundColor: const Color(0xFFFEF5F4),
    onTap: () {},
  ),
  SignInCardModel(
    image: ConstImages.facebookIcon,
    backgroundColor: const Color(0xFFF3F8FE),
    onTap: () {},
  ),
  SignInCardModel(
    image: ConstImages.microsoftIcon,
    backgroundColor: const Color(0xFFF5FAF6),
    onTap: () {},
  ),
];
