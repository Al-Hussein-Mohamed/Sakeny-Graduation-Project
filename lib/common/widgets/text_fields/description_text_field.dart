import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class DescriptionTextField extends StatefulWidget {
  const DescriptionTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.descriptionController,
    required this.hintText,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController descriptionController;
  final FocusNode? focusNode;
  final String hintText;


  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  bool isDescriptionValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isDescriptionValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(
            context,
            ConstColors.lightWrongInputField,
            ConstColors.darkWrongInputField,
          );
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        maxLines: 4,
        controller: widget.descriptionController,
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
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        validator: _validateDescription,
      ),
    );
  }

  String? _validateDescription(final String? value) {
    final res = Validator.validateDescription(context, value);
    if ((res == null) != isDescriptionValid) {
      setState(() => isDescriptionValid = !isDescriptionValid);
    }
    return res;
  }
}
