import 'package:flutter/cupertino.dart';
import 'package:sakeny/features/filters/screens/widgets/value_button.dart';

class ValueSelectionRow extends StatefulWidget {
  const ValueSelectionRow({
    super.key,
    required this.segmentsMap,
    required this.value,
    required this.onChanged,
  });
  final Map<Object, ValueButton> segmentsMap;
  final dynamic value;
  final Function(dynamic) onChanged;

  @override
  State<ValueSelectionRow> createState() => _ValueSelectionRowState();
}

class _ValueSelectionRowState extends State<ValueSelectionRow> {
  dynamic currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl(
        children: widget.segmentsMap,
        groupValue: widget.value,
        onValueChanged: (value) {
          if (value != null) {
            currentValue = value;
            widget.onChanged(value);
          }
        },
      ),
    );
  }
}
