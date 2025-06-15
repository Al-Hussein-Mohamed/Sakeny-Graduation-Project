import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/text_fields/price_text_field.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class PriceRangeFieldsRow extends StatelessWidget {
  const PriceRangeFieldsRow({
    super.key,
    required this.lang,
    required this.filtersCubit,
  });

  final S lang;
  final FiltersCubit filtersCubit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: PriceTextField(
            label: lang.minimum,
            hintText: "0",
            priceController: filtersCubit.priceMinController,
            padding: const EdgeInsets.all(0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: Text(
            lang.to,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.bodySmall
                : CustomTextTheme.darkTextTheme.bodySmall,
          ),
        ),
        Expanded(
          child: PriceTextField(
            label: lang.maximum,
            hintText: lang.any,
            priceController: filtersCubit.priceMaxController,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
