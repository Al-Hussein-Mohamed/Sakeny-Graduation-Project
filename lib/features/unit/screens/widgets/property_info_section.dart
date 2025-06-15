part of "../unit_screen.dart";

class _PropertyInfoSection extends StatelessWidget {
  const _PropertyInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final UnitModel unit = InheritedUnit.of(context);
    final AppColors colors = AppColors.of(context);
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    final RentFrequency? rentFreq = getRentFrequencyByUnitModel(unit);
    final int? bedCount = getBedCountByUnitModel(unit);
    final int? roomCount = getRoomCountByUnitModel(unit);

    final String priceText = "${unit.price} ${lang.egp} ${rentFreq?.getString(context) ?? ""}";
    final String furnishedText = unit.isFurnished ? lang.unit_isFurnished : lang.unit_notFurnished;
    final String areaText = "${unit.unitArea} ${lang.unit_mSquare}";
    final String dateText = "${unit.date.day} ${getMonthName(unit.date.month)} ${unit.date.year}";

    return Column(
      spacing: 15,
      children: [
        _firstRow(context, lang, colors, theme),
        const SizedBox(height: 5),
        _PropInfo(lang.unit_owner, unit.ownerName),
        _PropInfo(lang.unit_type, unit.unitType.getString(context)),
        _PropInfo(lang.unit_price, priceText),
        _PropInfo(lang.unit_furnishing, furnishedText),
        _PropInfo(lang.unit_location, unit.address),
        _PropInfo(lang.unit_added_on, dateText),
        _PropInfo(lang.unit_area, areaText),
        _PropInfo(lang.unit_gender, unit.gender.getString(context)),
        // rate
        _rateRow(context, unit.unitRate, unit.unitRateCount),
        _PropInfo(lang.unit_level, unit.floor.toString()),
        if (roomCount != null) _PropInfo(lang.unit_rooms, roomCount.toString()),
        if (bedCount != null) _PropInfo(lang.unit_beds, bedCount.toString()),
        _PropInfo(lang.unit_bathrooms, unit.bathRoomCount.toString()),
        // const SizedBox(height: 5),
        const Divider(color: Colors.grey, height: 1),
      ],
    );
  }

  Row _firstRow(context, S lang, AppColors colors, ThemeData theme) {
    final UnitModel unit = InheritedUnit.of(context);
    final PostModel post = InheritedUnit.postOf(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lang.unit_property_information),
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              PageRouteNames.mapShowUnits,
              arguments: MapShowUnitsArgs(post: post),
            );
          },
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(child: Icon(Icons.location_on, color: colors.text, size: 20)),
                TextSpan(text: lang.unit_show_on_map, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        // Text(lang.unit_show_on_map),
      ],
    );
  }

  Row _rateRow(BuildContext context, num rating, int ratingCount) {
    final S lang = S.of(context);
    final ThemeData theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            lang.unit_rate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: CustomColorScheme.getColor(context, CustomColorScheme.drawerTile),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: RatingStars(rating: rating.toDouble(), ratingCount: ratingCount),
          ),
        ),
      ],
    );
  }
}

class _PropInfo extends StatelessWidget {
  const _PropInfo(this.firstText, this.secondText);

  final String firstText;
  final String secondText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            firstText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: CustomColorScheme.getColor(context, CustomColorScheme.drawerTile),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            secondText,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 15.spMin,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
