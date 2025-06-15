import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';

class ViewProfilePicture extends StatelessWidget {
  const ViewProfilePicture({
    super.key,
    required this.profilePictureURL,
    required this.profilePictureSize,
    this.onTap,
  });

  final String? profilePictureURL;
  final double profilePictureSize;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColors colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: profilePictureURL != null
          ? Container(
              height: profilePictureSize,
              width: profilePictureSize,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: profilePictureURL!,
                cacheKey: profilePictureURL,
                fit: BoxFit.cover,
                height: profilePictureSize,
                width: profilePictureSize,
                placeholder: (context, url) => Image.asset(
                  ConstImages.profilePic,
                  fit: BoxFit.cover,
                  width: profilePictureSize,
                  height: profilePictureSize,
                ),
                errorWidget: (context, url, error) => Container(
                  color: colors.primary,
                  child: Icon(Icons.error_outline, color: colors.text),
                ),
              ),
            )
          : Image.asset(
              ConstImages.profilePic,
              fit: BoxFit.cover,
              width: profilePictureSize,
              height: profilePictureSize,
            ),
    );
  }
}
