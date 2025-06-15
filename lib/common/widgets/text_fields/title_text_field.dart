import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class TitleTextField extends StatefulWidget {
  const TitleTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.hintText,
    required this.titleController,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController titleController;
  final FocusNode? focusNode;
  final String hintText;
  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  bool isTitleValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isTitleValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(
            context,
            ConstColors.lightWrongInputField,
            ConstColors.darkWrongInputField,
          );

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.titleController,
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
        textInputAction: TextInputAction.next,
        validator: _validateTitle,
      ),
    );
  }

  String? _validateTitle(final String? value) {
    final res = Validator.validateTitle(context, value);
    if ((res == null) != isTitleValid) {
      setState(() => isTitleValid = !isTitleValid);
    }
    return res;
  }
}
