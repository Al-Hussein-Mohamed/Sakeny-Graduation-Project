import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';
import 'package:sakeny/generated/l10n.dart';

class OptionsModalBottomSheets {
  static Future<int?> selectOptionFromBottomSheetLevel(
    BuildContext context,
    S lang,
  ) async {
    // this function for level option only as the it goes from ground to +10
    return await showModalBottomSheet<int>(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? ConstColors.scaffoldBackground
          : ConstColors.scaffoldBackgroundDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    lang.level,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ConstColors.dividerColor),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      lang.ground,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 0);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "1",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 1);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "2",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 2);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "3",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 3);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "4",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 4);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "5",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 5);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "6",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 6);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "7",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 7);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "8",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 8);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "9",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 9);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "+10",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 10);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<int?> selectOptionFromBottomSheetGeneral(
    BuildContext context,
    String title,
  ) async {
    return await showModalBottomSheet<int>(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? ConstColors.scaffoldBackground
          : ConstColors.scaffoldBackgroundDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ConstColors.dividerColor),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      "1",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 1);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "2",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 2);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "3",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 3);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "4",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 4);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "5",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 5);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "6",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 6);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "7",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 7);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "8",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 8);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "9",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 9);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      "+10",
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, 10);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<RentFrequency?> selectOptionFromBottomSheetRentalFrequency(
    BuildContext context,
    S lang,
  ) async {
    // this function Rental Frequency
    return await showModalBottomSheet<RentFrequency>(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? ConstColors.scaffoldBackground
          : ConstColors.scaffoldBackgroundDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    lang.rentalFrequency,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: ConstColors.dividerColor),
            Flexible(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16, top: 4),
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text(
                      lang.enumDaily,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, RentFrequency.daily);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      lang.enumWeekly,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, RentFrequency.weekly);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      lang.enumMonthly,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, RentFrequency.monthly);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: ConstColors.dividerColor,
                  ),
                  ListTile(
                    title: Text(
                      lang.enumYearly,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                    onTap: () {
                      Navigator.pop(context, RentFrequency.yearly);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<NearbyServicesModel?> selectNearbyServicesFromBottomSheet(
    BuildContext context,
    S lang,
    NearbyServicesModel initialServices,
  ) async {
    // Create a mutable copy of the services map
    final Map<String, bool> servicesMap =
        Map<String, bool>.from(initialServices.services);

    return await showModalBottomSheet<NearbyServicesModel>(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? ConstColors.scaffoldBackground
          : ConstColors.scaffoldBackgroundDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.nearbyServices,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: ConstColors.dividerColor),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: KNearbyServicesKeys.allKeys.map((serviceKey) {
                      return CheckboxListTile(
                        title: Text(
                          KNearbyServicesKeys.getTitle(context, serviceKey),
                          style:
                              Theme.of(context).brightness == Brightness.light
                                  ? CustomTextTheme.lightTextTheme.bodyMedium
                                  : CustomTextTheme.darkTextTheme.bodyMedium,
                        ),
                        secondary: SvgPicture.asset(
                          KNearbyServicesKeys.serviceIcon[serviceKey]!,
                          width: 24, // Optional size
                          height: 24, // Optional size
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            BlendMode.srcIn,
                          ), // Optional color
                        ),
                        activeColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        checkColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                        side: BorderSide(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          width: 2,
                        ),
                        value: servicesMap[serviceKey],
                        onChanged: (bool? value) {
                          setState(() {
                            servicesMap[serviceKey] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      final newModel = NearbyServicesModel(
                        mask: 0, // Will be calculated by toMask()
                        services: servicesMap,
                      );
                      Navigator.pop(context, newModel);
                    },
                    child: Text(
                      lang.apply,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(color: Colors.white)
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static Future<ServicesModel?> selectServicesFromBottomSheet(
    BuildContext context,
    S lang,
    ServicesModel initialServices,
  ) async {
    // Create a mutable copy of the services map
    final Map<String, bool> servicesMap =
        Map<String, bool>.from(initialServices.services);

    return await showModalBottomSheet<ServicesModel>(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? ConstColors.scaffoldBackground
          : ConstColors.scaffoldBackgroundDark,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.featureAndAmenities,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: ConstColors.dividerColor),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: KServicesKeys.allKeys.map((serviceKey) {
                      return CheckboxListTile(
                        title: Text(
                          KServicesKeys.getTitle(context, serviceKey),
                          style:
                              Theme.of(context).brightness == Brightness.light
                                  ? CustomTextTheme.lightTextTheme.bodyMedium
                                  : CustomTextTheme.darkTextTheme.bodyMedium,
                        ),
                        secondary: SvgPicture.asset(
                          KServicesKeys.serviceIcon[serviceKey]!,
                          width: 24, // Optional size
                          height: 24, // Optional size
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                            BlendMode.srcIn,
                          ), // Optional color
                        ),
                        activeColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                        checkColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black,
                        side: BorderSide(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                          width: 2,
                        ),
                        value: servicesMap[serviceKey],
                        onChanged: (bool? value) {
                          setState(() {
                            servicesMap[serviceKey] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      final newModel = ServicesModel(
                        msk: 0, // Will be calculated by toMask()
                        services: servicesMap,
                      );
                      Navigator.pop(context, newModel);
                    },
                    child: Text(
                      lang.apply,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodyMedium
                              ?.copyWith(color: Colors.white)
                          : CustomTextTheme.darkTextTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
