import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:sakeny/common/models/user_model.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/theme/widget_themes/app_colors.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';
import 'package:sakeny/core/utils/extensions/dynamic_text_direction_extension.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/home/controllers/home_cubit.dart';
import 'package:sakeny/features/post/comments/controllers/comment_cubit.dart';
import 'package:sakeny/features/post/comments/screens/post_comments_bottom_sheet.dart';
import 'package:sakeny/features/post/posts/controllers/inherited_post.dart';
import 'package:sakeny/features/post/posts/controllers/post_cubit.dart';
import 'package:sakeny/features/post/posts/controllers/post_synchronizer.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/post/posts/widgets/edit_post_footer.dart';
import 'package:sakeny/features/post/posts/widgets/rating_starts.dart';
import 'package:sakeny/features/profile/profile/models/profile_args.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';
import 'package:sakeny/generated/l10n.dart';

part '../widgets/post_body.dart';
part '../widgets/post_footer.dart';
part '../widgets/post_header.dart';
part '../widgets/post_image.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.index,
    this.isEditing = false,
  });

  final int index;
  final PostModel post;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final double borderThickness = .9;
    final double dividerThickness = .5;

    return InheritedPost(
      post: post,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurface,
          border: Border.all(
            color: post.unit.isRented
                ? ConstColors.postGreen
                : CustomColorScheme.getColor(context, CustomColorScheme.postBorder),
            width: borderThickness,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostHeader(
              userName: post.userName,
              userId: post.userId,
              userRate: post.userRate,
              profilePictureURL: post.userProfilePicUrl,
              postId: post.postId,
              date: post.date,
            ),
            _PostImage(
              index: index,
              postId: post.postId,
              imageUrl: post.unit.unitPicturesUrls[0],
              isFavorite: post.isFavorite,
              isRented: post.unit.isRented,
              cacheKey: post.unit.unitId.toString(),
            ),
            _PostBody(
              post: post,
            ),
            Divider(
              color: CustomColorScheme.getColor(context, CustomColorScheme.postBorder),
              thickness: dividerThickness,
              height: dividerThickness,
            ),
            _PostFooter(
              postId: post.postId,
              unitId: post.unit.unitId,
              isEditing: isEditing,
              idx: index,
              isLiked: post.isLiked,
              isRented: post.unit.isRented,
              likeCount: post.likesCount,
              commentCount: post.commentsCount,
            ),
          ],
        ),
      ),
    );
  }
}
