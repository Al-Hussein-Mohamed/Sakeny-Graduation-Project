part of '../unit_screen.dart';

class _RateUnit extends StatelessWidget {
  const _RateUnit();

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    return Container(
      width: MediaQuery.of(context).size.width * .85,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: getTextColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.rateThisUnit),
          const SizedBox(height: 8),
          const Align(child: _RatingStars()),
        ],
      ),
    );
  }
}

class _RatingStars extends StatefulWidget {
  const _RatingStars();

  @override
  State<_RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<_RatingStars> {
  late double rate;

  @override
  void initState() {
    rate = 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final unit = InheritedUnit.of(context);
    setState(() => rate = (unit.visitorRate ?? 0).toDouble());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final UnitCubit unitCubit = context.read<UnitCubit>();
    final post = InheritedUnit.postOf(context);

    return SmoothStarRating(
      rating: rate,
      onRatingChanged: (nRate) {
        unitCubit.addUnitRate(
          context: context,
          rate: nRate,
          post: post,
        );
        setState(() => rate = nRate);
      },
      color: Colors.yellow[800],
      borderColor: Colors.yellow[800],
      size: 30,
      spacing: 2,
    );
  }
}
