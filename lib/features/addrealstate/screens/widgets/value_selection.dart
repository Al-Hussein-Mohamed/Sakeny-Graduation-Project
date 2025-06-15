import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/unit/models/nearby_services_model.dart';
import 'package:sakeny/features/unit/models/service_model.dart';
import 'package:sakeny/generated/l10n.dart';

class ValueSelection extends StatelessWidget {
  const ValueSelection({
    super.key,
    required this.label,
    required this.onTap,
    required this.value,
  });

  final String label;
  final VoidCallback onTap;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    final S lang = S.of(context);
    final Color color = value != null
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(
            context,
            ConstColors.lightWrongInputField,
            ConstColors.darkWrongInputField,
          );
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle().copyWith(color: color),
          border: const OutlineInputBorder(),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: value == null ||
                    value is LatLng ||
                    value is ServicesModel ||
                    value is NearbyServicesModel
                ? Row(
                    children: [
                      Text(
                        lang.select,
                        style: Theme.of(context).brightness == Brightness.light
                            ? CustomTextTheme.lightTextTheme.bodySmall
                            : CustomTextTheme.darkTextTheme.bodySmall,
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ],
                  )
                : value == 0
                    ? Text(
                        lang.ground,
                        style: Theme.of(context).brightness == Brightness.light
                            ? CustomTextTheme.lightTextTheme.bodySmall
                            : CustomTextTheme.darkTextTheme.bodySmall,
                      )
                    : Text(
                        value is RentFrequency
                            ? _getReadableRentFrequency(value, context)
                            : value.toString(),
                        style: Theme.of(context).brightness == Brightness.light
                            ? CustomTextTheme.lightTextTheme.bodySmall
                            : CustomTextTheme.darkTextTheme.bodySmall,
                      ),
          ),
        ),
      ),
    );
  }
}

String _getReadableRentFrequency(
  //get string function in the enum didn't work idk why
  RentFrequency frequency,
  BuildContext context,
) {
  final S lang = S.of(context);
  switch (frequency) {
    case RentFrequency.daily:
      return lang.enumDaily;
    case RentFrequency.weekly:
      return lang.enumWeekly;
    case RentFrequency.monthly:
      return lang.enumMonthly;
    case RentFrequency.yearly:
      return lang.enumYearly;
  }
}
