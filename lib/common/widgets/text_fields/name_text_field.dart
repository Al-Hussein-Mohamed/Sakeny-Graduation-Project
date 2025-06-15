import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class NameTextField extends StatefulWidget {
  const NameTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.nameController,
    this.onChanged,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController nameController;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  bool isNameValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isNameValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(context, ConstColors.lightWrongInputField, ConstColors.darkWrongInputField);

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.nameController,
        focusNode: widget.focusNode,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: 17.spMin,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: ImageIcon(
            const AssetImage(ConstImages.nameIcon),
            color: color,
          ),
          label: Text(widget.label, style: const TextStyle().copyWith(color: color)),
        ),
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        validator: _validateName,
        onChanged: widget.onChanged,
      ),
    );
  }

  String? _validateName(final String? value) {
    final res = Validator.validateName(context, value);
    if ((res == null) != isNameValid) {
      setState(() => isNameValid = !isNameValid);
    }
    return res;
  }
}
