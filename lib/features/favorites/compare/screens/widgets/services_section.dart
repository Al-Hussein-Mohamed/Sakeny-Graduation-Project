import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/features/unit/models/service_model.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({
    super.key,
    required this.title,
    required this.post1Services,
    required this.post2Services,
  });

  final String title;
  final ServicesModel post1Services;
  final ServicesModel post2Services;

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
                  child: _buildServiceIcons(context, post1Services),
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
                  child: _buildServiceIcons(context, post2Services),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcons(BuildContext context, ServicesModel services) {
    final List<Widget> serviceIcons = [];
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Get all available services for this unit
    for (String serviceKey in KServicesKeys.allKeys) {
      if (services.services[serviceKey] == true) {
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
              KServicesKeys.serviceIcon[serviceKey] ?? '',
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
        'No services available',
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
