import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class AreaTextField extends StatefulWidget {
  const AreaTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.hintText,
    required this.areaController,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController areaController;
  final FocusNode? focusNode;
  final String hintText;

  @override
  State<AreaTextField> createState() => _AreaTextFieldState();
}

class _AreaTextFieldState extends State<AreaTextField> {
  bool isAreaValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isAreaValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(
            context,
            ConstColors.lightWrongInputField,
            ConstColors.darkWrongInputField,
          );

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.areaController,
        focusNode: widget.focusNode,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: 17.spMin,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: const TextStyle().copyWith(color: color),
          ),
          hintText: widget.hintText,
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        validator: _validateArea,
      ),
    );
  }

  String? _validateArea(final String? value) {
    final res = Validator.validateArea(context, value);
    if ((res == null) != isAreaValid) {
      setState(() => isAreaValid = !isAreaValid);
    }
    return res;
  }
}
