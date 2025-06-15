part of '../screens/post_widget.dart';

class _PostBody extends StatelessWidget {
  const _PostBody({required this.post});

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _postBodyFirstRow(context, theme),
          const SizedBox(height: 8),
          _postBodySecondRow(context),
          const SizedBox(height: 8),
          _postBodyThirdRow(theme),
        ],
      ),
    );
  }

  Row _postBodyFirstRow(BuildContext context, ThemeData theme) {
    // TODO: show Room count instead of bed count if it not a room
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(post.unit.unitType.getString(context), style: theme.textTheme.bodyMedium),
        PostUnitInfoWidget(unit: post.unit),
      ],
    );
  }

  Row _postBodySecondRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PostUnitPriceInfo(context: context, unit: post.unit),
        RatingStars(
          rating: double.parse(post.unit.unitRate.toString()),
          ratingCount: post.unit.unitRateCount,
          key: ValueKey(post.postId),
        ),
      ],
    );
  }

  Align _postBodyThirdRow(ThemeData theme) {
    return Text(
      post.unit.address,
      style: theme.textTheme.bodySmall,
    ).withAutomaticDirectionAlign();
  }
}

class PostUnitPriceInfo extends StatelessWidget {
  const PostUnitPriceInfo({
    super.key,
    required this.context,
    required this.unit,
  });

  final BuildContext context;
  final UnitModel unit;

  RentFrequency? _getRentFrequency() {
    switch (unit) {
      case RoomRental():
        return (unit as RoomRental).rentalFrequency;
      case ApartmentAndHouseRental():
        return (unit as ApartmentAndHouseRental).rentalFrequency;
      case ApartmentAndHouseSale():
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final RentFrequency? rentFrequency = _getRentFrequency();
    final NumberFormat numberFormat =
        NumberFormat.decimalPattern(Localizations.localeOf(context).toString());

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${numberFormat.format(unit.price)} ${lang.egp}",
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
          ),
          if (rentFrequency != null)
            TextSpan(
              text: "  ${rentFrequency.getString(context)}",
              style: theme.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}

class PostUnitInfoWidget extends StatelessWidget {
  const PostUnitInfoWidget({super.key, required this.unit});

  final UnitModel unit;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppColors colors = AppColors.of(context);
    final double iconSize = 14;
    final int? bedsCount = unit is RoomRental ? (unit as RoomRental).numberOfBeds : null;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: RichText(
        text: TextSpan(
          children: [
            if (bedsCount != null)
              WidgetSpan(
                child: SvgPicture.asset(
                  ConstImages.postBed,
                  width: iconSize,
                  height: iconSize,
                  colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
                ),
                alignment: PlaceholderAlignment.middle,
              ),
            if (bedsCount != null)
              TextSpan(text: " $bedsCount  ", style: theme.textTheme.bodySmall),
            WidgetSpan(
              child: SvgPicture.asset(
                ConstImages.postBathroom,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(text: " ${unit.bathRoomCount}  ", style: theme.textTheme.bodySmall),
            WidgetSpan(
              child: SvgPicture.asset(
                ConstImages.postArea,
                width: iconSize,
                height: iconSize,
                colorFilter: ColorFilter.mode(colors.text, BlendMode.srcIn),
              ),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(
              text: " ${unit.unitArea % 1 == 0 ? unit.unitArea.toInt() : unit.unitArea}m²",
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
