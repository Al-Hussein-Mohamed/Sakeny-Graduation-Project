import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/widget_themes/custom_text_theme.dart';
import 'package:sakeny/features/addrealstate/controllers/add_real_estate_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class RadioButtonsFurnished extends StatefulWidget {
  const RadioButtonsFurnished({
    super.key,
    required this.lang,
    required this.addRealEstateCubit,
  });

  final S lang;
  final AddRealEstateCubit addRealEstateCubit;

  @override
  State<RadioButtonsFurnished> createState() => _RadioButtonsFurnishedState();
}

class _RadioButtonsFurnishedState extends State<RadioButtonsFurnished> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Text(
            widget.lang.furnished,
            style: Theme.of(context).brightness == Brightness.light
                ? CustomTextTheme.lightTextTheme.bodyMedium
                : CustomTextTheme.darkTextTheme.bodyMedium,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  widget.lang.yes,
                  style: Theme.of(context).brightness == Brightness.light
                      ? CustomTextTheme.lightTextTheme.bodySmall
                      : CustomTextTheme.darkTextTheme.bodySmall,
                ),
                value: true,
                groupValue: widget.addRealEstateCubit.isFurnished,
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
                    widget.addRealEstateCubit.isFurnished = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text(
                  widget.lang.no,
                  style: Theme.of(context).brightness == Brightness.light
                      ? CustomTextTheme.lightTextTheme.bodySmall
                      : CustomTextTheme.darkTextTheme.bodySmall,
                ),
                value: false,
                groupValue: widget.addRealEstateCubit.isFurnished,
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
                    widget.addRealEstateCubit.isFurnished = value;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
