import 'package:flutter/material.dart';
import 'package:sakeny/common/widgets/text_fields/area_text_field.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class AreaRangeFieldsRow extends StatelessWidget {
  const AreaRangeFieldsRow({
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
          child: AreaTextField(
            label: lang.minimum,
            hintText: "0",
            areaController: filtersCubit.areaMinController,
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
          child: AreaTextField(
            label: lang.maximum,
            hintText: lang.any,
            areaController: filtersCubit.areaMaxController,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
