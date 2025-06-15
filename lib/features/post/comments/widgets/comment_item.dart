part of '../screens/post_comments_bottom_sheet.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.comment});

  final CommentModel comment;

  void _viewProfile(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();

    final ProfileArgs profileArgs = ProfileArgs(
      userState: homeCubit.user,
      userId: comment.userId,
      userName: comment.userName,
      userProfilePictureUrl: comment.userProfilePictureURL,
      userRate: comment.userRate,
    );
    Navigator.pushNamed(context, PageRouteNames.profile, arguments: profileArgs);
  }

  @override
  Widget build(BuildContext context) {
    const double profilePictureSize = 35;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _viewProfile(context),
            child: ViewProfilePicture(
              profilePictureURL: comment.userProfilePictureURL,
              profilePictureSize: profilePictureSize,
            ),
          ),
          _Content(comment: comment, viewProfile: _viewProfile),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.comment,
    required this.viewProfile,
  });

  final CommentModel comment;
  final Function(BuildContext context) viewProfile;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color backgroundColor = theme.brightness == Brightness.light
        ? Colors.grey[300]!
        : ConstColors.onScaffoldBackgroundDark.withValues(alpha: .6);

    final settingsProvider = sl<SettingsProvider>();
    final bool isEnglish = settingsProvider.isEn;

    return Expanded(
      child: Container(
        margin: const EdgeInsetsDirectional.only(start: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => viewProfile(context),
                  child: Text(
                    comment.userName,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Text(
                  isEnglish
                      ? _getTimeAgoEnglish(comment.egyptTime)
                      : _getTimeAgoArabic(comment.egyptTime),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              comment.content,
              textAlign: TextAlign.start,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Converts a DateTime to a "time ago" format in English (e.g., "2 hours ago")
  String _getTimeAgoEnglish(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Within the last minute
    if (difference.inSeconds < 60) {
      return 'just now';
    }

    // Within the last hour
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }

    // Within the last day
    if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    }

    // Within the last week
    if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    }

    // Within the last month
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    // Within the last year
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    // More than a year
    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }

  /// Converts a DateTime to a "time ago" format in Arabic
  String _getTimeAgoArabic(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // Within the last minute
    if (difference.inSeconds < 60) {
      return 'الآن';
    }

    // Within the last hour
    if (difference.inMinutes < 60) {
      if (difference.inMinutes == 1) {
        return 'منذ دقيقة';
      } else if (difference.inMinutes == 2) {
        return 'منذ دقيقتين';
      } else if (difference.inMinutes >= 3 && difference.inMinutes <= 10) {
        return 'منذ ${difference.inMinutes} دقائق';
      } else {
        return 'منذ ${difference.inMinutes} دقيقة';
      }
    }

    // Within the last day
    if (difference.inHours < 24) {
      if (difference.inHours == 1) {
        return 'منذ ساعة';
      } else if (difference.inHours == 2) {
        return 'منذ ساعتين';
      } else if (difference.inHours >= 3 && difference.inHours <= 10) {
        return 'منذ ${difference.inHours} ساعات';
      } else {
        return 'منذ ${difference.inHours} ساعة';
      }
    }

    // Within the last week
    if (difference.inDays < 7) {
      if (difference.inDays == 1) {
        return 'منذ يوم';
      } else if (difference.inDays == 2) {
        return 'منذ يومين';
      } else {
        return 'منذ ${difference.inDays} أيام';
      }
    }

    // Within the last month
    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      if (weeks == 1) {
        return 'منذ أسبوع';
      } else if (weeks == 2) {
        return 'منذ أسبوعين';
      } else {
        return 'منذ $weeks أسابيع';
      }
    }

    // Within the last year
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      if (months == 1) {
        return 'منذ شهر';
      } else if (months == 2) {
        return 'منذ شهرين';
      } else if (months >= 3 && months <= 10) {
        return 'منذ $months أشهر';
      } else {
        return 'منذ $months شهر';
      }
    }

    // More than a year
    final years = (difference.inDays / 365).floor();
    if (years == 1) {
      return 'منذ سنة';
    } else if (years == 2) {
      return 'منذ سنتين';
    } else if (years >= 3 && years <= 10) {
      return 'منذ $years سنوات';
    } else {
      return 'منذ $years سنة';
    }
  }
}

/// A shimmer loading effect version of the CommentItem widget
class CommentItemShimmer extends StatelessWidget {
  const CommentItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CustomColorScheme.getColor(context, CustomColorScheme.postShimmerBase),
      highlightColor: CustomColorScheme.getColor(context, CustomColorScheme.postShimmerHighlight),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture shimmer
            Container(
              height: 35,
              width: 35,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsetsDirectional.only(start: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and time row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Username shimmer
                        Container(
                          height: 14,
                          width: 120,
                          color: Colors.white,
                        ),
                        // Time ago shimmer
                        Container(
                          height: 12,
                          width: 60,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Comment content shimmer - first line
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    // Comment content shimmer - second line
                    Container(
                      height: 12,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
