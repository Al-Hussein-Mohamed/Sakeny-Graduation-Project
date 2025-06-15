import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_images.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
    required this.selectProfilePic,
    required this.clearProfilePic,
    required this.getProfilePic,
    this.profilePicUrl,
  });

  final Future<void> Function() selectProfilePic;
  final void Function() clearProfilePic;
  final File? Function() getProfilePic;
  final String? profilePicUrl;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? img;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    return Center(
      child: SizedBox(
        width: 130,
        height: 130,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 65,
              backgroundColor: scaffoldBackgroundColor,
              child: ClipOval(
                child: _ProfilePic(img: img, profilePicUrl: widget.profilePicUrl),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                color: Colors.black,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () async {
                    if (img == null && widget.profilePicUrl == null) {
                      await widget.selectProfilePic();
                    } else {
                      widget.clearProfilePic();
                    }
                    setState(() {
                      img = widget.getProfilePic();
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      img == null && widget.profilePicUrl == null
                          ? Icons.add_a_photo_outlined
                          : Icons.clear_outlined,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePic extends StatelessWidget {
  const _ProfilePic({this.img, this.profilePicUrl});

  final File? img;
  final String? profilePicUrl;

  @override
  Widget build(BuildContext context) {
    if (profilePicUrl != null) {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: profilePicUrl!,
            placeholder: (ctx, url) => Image.asset(
              ConstImages.profilePic,
              fit: BoxFit.cover,
            ),
            errorWidget: (ctx, url, error) => const Center(child: Icon(Icons.error)),
          ),
        ),
      );
    }

    if (img != null) {
      return Image.file(
        img!,
        fit: BoxFit.cover,
        width: 130,
        height: 130,
      );
    }

    return Image.asset(
      ConstImages.profilePic,
      fit: BoxFit.cover,
      width: 130,
      height: 130,
    );
  }
}
