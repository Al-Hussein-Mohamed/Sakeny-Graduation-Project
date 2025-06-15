import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';

class NearbyServicesSection extends StatelessWidget {
  const NearbyServicesSection({
    super.key,
    required this.title,
    required this.post1NearbyServices,
    required this.post2NearbyServices,
  });

  final String title;
  final NearbyServicesModel post1NearbyServices;
  final NearbyServicesModel post2NearbyServices;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: _buildNearbyServiceIcons(context, post1NearbyServices),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDarkMode ? ConstColors.darkPrimary : ConstColors.grey,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: _buildNearbyServiceIcons(context, post2NearbyServices),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyServiceIcons(
      BuildContext context, NearbyServicesModel nearbyServices) {
    final List<Widget> serviceIcons = [];
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Get all available nearby services for this unit
    for (String serviceKey in KNearbyServicesKeys.allKeys) {
      if (nearbyServices.services[serviceKey] == true) {
        serviceIcons.add(
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ConstColors.onScaffoldBackgroundDark
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: SvgPicture.asset(
              KNearbyServicesKeys.serviceIcon[serviceKey] ?? '',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isDarkMode ? Colors.white : ConstColors.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      }
    }

    if (serviceIcons.isEmpty) {
      return Text(
        'No nearby services',
        textAlign: TextAlign.center,
        style: TextStyle(
          color:
              isDarkMode ? ConstColors.drawerTileDark : ConstColors.drawerTile,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: serviceIcons,
    );
  }
}
