import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/view_profile_picture.dart';
import 'package:sakeny/core/constants/const_colors.dart';

class OwnerComparisonSection extends StatelessWidget {
  const OwnerComparisonSection({
    super.key,
    required this.title,
    required this.owner1Name,
    required this.owner1ProfilePicture,
    required this.owner2Name,
    required this.owner2ProfilePicture,
  });

  final String title;
  final String owner1Name;
  final String? owner1ProfilePicture;
  final String owner2Name;
  final String? owner2ProfilePicture;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : ConstColors.primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                    ),
                  ),
                  child: _buildOwnerProfile(context, owner1Name, owner1ProfilePicture),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode ? Colors.grey.withOpacity(0.3) : Colors.transparent,
                    ),
                  ),
                  child: _buildOwnerProfile(context, owner2Name, owner2ProfilePicture),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerProfile(BuildContext context, String ownerName, String? profilePictureUrl) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ViewProfilePicture(profilePictureURL: profilePictureUrl, profilePictureSize: 50),
          // child: CircleAvatar(
          //   radius: 30,
          //   backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          //   backgroundImage:
          //       profilePictureUrl != null && profilePictureUrl.isNotEmpty
          //           ? NetworkImage(profilePictureUrl)
          //           : null,
          //   child: profilePictureUrl == null || profilePictureUrl.isEmpty
          //       ? Icon(
          //           Icons.person,
          //           size: 30,
          //           color: Theme.of(context).primaryColor,
          //         )
          //       : null,
          //   onBackgroundImageError: (exception, stackTrace) {
          //     // Handle image loading error
          //   },
          // ),
        ),
        const SizedBox(height: 8),
        Text(
          ownerName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : ConstColors.primaryColor,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
