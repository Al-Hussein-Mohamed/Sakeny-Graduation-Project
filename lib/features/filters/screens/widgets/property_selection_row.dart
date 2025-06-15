import 'package:flutter/cupertino.dart';
import 'package:sakeny/features/filters/controllers/filter_cubit.dart';
import 'package:sakeny/features/filters/screens/widgets/property_button.dart';

class PropertySelectionRow extends StatefulWidget {
  const PropertySelectionRow({
    super.key,
    required this.filtersCubit,
    required this.segmentsMap,
  });

  final FiltersCubit filtersCubit;
  final Map<String, PropertyButton> segmentsMap;
  @override
  State<PropertySelectionRow> createState() => _PropertySelectionRowState();
}

class _PropertySelectionRowState extends State<PropertySelectionRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl(
        children: widget.segmentsMap,
        groupValue: widget.filtersCubit.unitType,
        onValueChanged: (value) {
          if (value != null) {
            setState(() {
              widget.filtersCubit.unitType = value;
            });
          }
        },
      ),
    );
  }
}
