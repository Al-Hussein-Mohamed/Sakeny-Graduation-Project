import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_enum.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class RadioButtonsGender extends StatefulWidget {
  const RadioButtonsGender({
    super.key,
    required this.lang,
    required this.addRealEstateCubit,
  });

  final S lang;
  final AddRealEstateCubit addRealEstateCubit;

  @override
  State<RadioButtonsGender> createState() => _RadioButtonsGenderState();
}

class _RadioButtonsGenderState extends State<RadioButtonsGender> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            widget.lang.gender,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.bodyMedium
                : CustomTextTheme.darkTextTheme.bodyMedium,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListTileTheme(
                horizontalTitleGap: 0, // Reduces gap between radio and text
                minLeadingWidth: 0,
                child: RadioListTile<Gender>(
                  dense: true,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.lang.enumGenderMale,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodySmall
                          : CustomTextTheme.darkTextTheme.bodySmall,
                    ),
                  ),
                  value: Gender.male,
                  groupValue: widget.addRealEstateCubit.gender,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white;
                    }
                    return Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade600 // Unselected color in light mode
                        : Colors.grey.shade400; // Unselected color in dark mode
                  }),
                  onChanged: (value) {
                    setState(() {
                      widget.addRealEstateCubit.gender = value;
                    });
                  },
                  contentPadding: const EdgeInsetsDirectional.only(end: 20),
                ),
              ),
            ),
            Expanded(
              child: ListTileTheme(
                horizontalTitleGap: 0, // Reduces gap between radio and text
                minLeadingWidth: 0,
                child: RadioListTile<Gender>(
                  dense: true,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.lang.enumGenderFemale,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodySmall
                          : CustomTextTheme.darkTextTheme.bodySmall,
                    ),
                  ),
                  value: Gender.female,
                  groupValue: widget.addRealEstateCubit.gender,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white;
                    }
                    return Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade600 // Unselected color in light mode
                        : Colors.grey.shade400; // Unselected color in dark mode
                  }),
                  onChanged: (value) {
                    setState(() {
                      widget.addRealEstateCubit.gender = value;
                    });
                  },
                  contentPadding: const EdgeInsetsDirectional.only(end: 20),
                ),
              ),
            ),
            Expanded(
              child: ListTileTheme(
                horizontalTitleGap: 0, // Reduces gap between radio and text
                minLeadingWidth: 0,
                child: RadioListTile<Gender>(
                  dense: true,
                  title: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.lang.any,
                      style: Theme.of(context).brightness == Brightness.light
                          ? CustomTextTheme.lightTextTheme.bodySmall
                          : CustomTextTheme.darkTextTheme.bodySmall,
                    ),
                  ),
                  value: Gender.any,
                  groupValue: widget.addRealEstateCubit.gender,
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white;
                    }
                    return Theme.of(context).brightness == Brightness.light
                        ? Colors.grey.shade600
                        : Colors.grey.shade400;
                  }),
                  onChanged: (value) {
                    setState(() {
                      widget.addRealEstateCubit.gender = value!;
                    });
                  },
                  contentPadding: const EdgeInsetsDirectional.only(end: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
