import 'package:flutter/material.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/comparison_section.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/nearby_services_section.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/owner_comparsion_section.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/property_card.dart';
import 'package:sakeny/features/favorites/compare/screens/widgets/services_section.dart';
import 'package:sakeny/features/post/posts/models/post_model.dart';
import 'package:sakeny/features/unit/models/unit_model/unit_model.dart';
import 'package:sakeny/generated/l10n.dart';

class CompareBody extends StatelessWidget {
  const CompareBody({super.key, required this.posts});

  final List<PostModel> posts;

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Property Images
          Row(
            children: [
              Expanded(
                child: PropertyCard(
                  imageUrl: posts[0].unit.unitPicturesUrls.isNotEmpty
                      ? posts[0].unit.unitPicturesUrls.first
                      : '',
                  title: posts[0].unit.title,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PropertyCard(
                  imageUrl: posts[1].unit.unitPicturesUrls.isNotEmpty
                      ? posts[1].unit.unitPicturesUrls.first
                      : '',
                  title: posts[1].unit.title,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Owner Comparison with Profile Pictures
          OwnerComparisonSection(
            title: lang.unit_owner,
            owner1Name: posts[0].unit.ownerName,
            owner1ProfilePicture: posts[0].unit.ownerProfilePictureUrl,
            owner2Name: posts[1].unit.ownerName,
            owner2ProfilePicture: posts[1].unit.ownerProfilePictureUrl,
          ),

          // Comparison Details
          ComparisonSection(
            title: lang.price,
            values: [
              '${posts[0].unit.price} ${lang.egp}',
              '${posts[1].unit.price} ${lang.egp}',
            ],
          ),

          ComparisonSection(
            title: lang.location,
            values: [
              posts[0].unit.address,
              posts[1].unit.address,
            ],
          ),

          ComparisonSection(
            title: lang.rate,
            values: [
              '${posts[0].unit.unitRate}',
              '${posts[1].unit.unitRate}',
            ],
            isRating: true,
          ),

          ComparisonSection(
            title: lang.size,
            values: [
              '${posts[0].unit.unitArea} m²',
              '${posts[1].unit.unitArea} m²',
            ],
          ),

          ComparisonSection(
            title: lang.furnished,
            values: [
              posts[0].unit.isFurnished ? lang.furnished : lang.unfurnished,
              posts[1].unit.isFurnished ? lang.furnished : lang.unfurnished,
            ],
          ),

          // Add rental frequency comparison (only for rental units)
          if (_shouldShowRentalFrequency(posts[0].unit) &&
              _shouldShowRentalFrequency(posts[1].unit))
            ComparisonSection(
              title: lang.rentalFrequency,
              values: [
                _getRentalFrequency(posts[0].unit, context),
                _getRentalFrequency(posts[1].unit, context),
              ],
            ),

          ComparisonSection(
            title: lang.addedOn,
            values: [
              _formatDate(posts[0].date, context),
              _formatDate(posts[1].date, context),
            ],
          ),

          ComparisonSection(
            title: lang.gender,
            values: [
              posts[0].unit.gender.getString(context),
              posts[1].unit.gender.getString(context),
            ],
          ),

          ComparisonSection(
            title: lang.level,
            values: [
              posts[0].unit.floor == 0 ? lang.ground : '${posts[0].unit.floor}',
              posts[1].unit.floor == 0 ? lang.ground : '${posts[1].unit.floor}',
            ],
          ),

          ComparisonSection(
            title: lang.bathrooms,
            values: [
              '${posts[0].unit.bathRoomCount}',
              '${posts[1].unit.bathRoomCount}',
            ],
          ),

          // Add rooms comparison (only for apartments and houses)
          if (_shouldShowRooms(posts[0].unit) && _shouldShowRooms(posts[1].unit))
            ComparisonSection(
              title: lang.rooms,
              values: [
                '${_getRoomCount(posts[0].unit)}',
                '${_getRoomCount(posts[1].unit)}',
              ],
            ),

          // Add beds comparison (only for room rentals)
          ComparisonSection(
            title: lang.beds,
            values: [
              '${_getBedCount(posts[0].unit)}',
              '${_getBedCount(posts[1].unit)}',
            ],
          ),

          // Features & Amenities
          ServicesSection(
            title: lang.featureAndAmenities,
            post1Services: posts[0].unit.services,
            post2Services: posts[1].unit.services,
          ),

          // Nearby Services
          NearbyServicesSection(
            title: lang.nearbyServices,
            post1NearbyServices: posts[0].unit.nearbyServices,
            post2NearbyServices: posts[1].unit.nearbyServices,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, BuildContext context) {
    final String day = date.day.toString();
    final String month = _getMonthName(date.month, context);
    final String year = date.year.toString();

    // Check if current locale is Arabic
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (isArabic) {
      // Convert numbers to Arabic numerals and format for RTL
      return '${_toArabicNumerals(year)} ،${month} ${_toArabicNumerals(day)}';
    } else {
      return '$day $month, $year';
    }
  }

  String _toArabicNumerals(String number) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', 'ن', '٧', '٨', '٩'];

    String result = number;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }

  String _getMonthName(int month, BuildContext context) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    if (isArabic) {
      const arabicMonths = [
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      return arabicMonths[month - 1];
    } else {
      const englishMonths = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return englishMonths[month - 1];
    }
  }

  // Helper methods for beds and rooms
  bool _shouldShowRooms(UnitModel unit) {
    return unit is ApartmentAndHouseRental || unit is ApartmentAndHouseSale;
  }

  bool _shouldShowRentalFrequency(UnitModel unit) {
    return unit is RoomRental || unit is ApartmentAndHouseRental;
  }

  String _getRentalFrequency(UnitModel unit, BuildContext context) {
    switch (unit) {
      case RoomRental():
        return unit.rentalFrequency.getString(context);
      case ApartmentAndHouseRental():
        return unit.rentalFrequency.getString(context);
      default:
        return '';
    }
  }

  int _getRoomCount(UnitModel unit) {
    switch (unit) {
      case ApartmentAndHouseRental():
        return unit.numberOfRooms;
      case ApartmentAndHouseSale():
        return unit.numberOfRooms;
      default:
        return 0;
    }
  }

  int _getBedCount(UnitModel unit) {
    switch (unit) {
      case RoomRental():
        return unit.numberOfBeds;
      case ApartmentAndHouseRental():
        // For apartments/houses, beds typically equal rooms since each room can have a bed
        return unit.numberOfRooms;
      case ApartmentAndHouseSale():
        // For sale units, beds typically equal rooms
        return unit.numberOfRooms;
      default:
        return 0;
    }
  }
}
