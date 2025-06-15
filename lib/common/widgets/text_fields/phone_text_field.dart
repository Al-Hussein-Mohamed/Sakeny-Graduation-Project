import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.phoneController,
    this.onChanged,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController phoneController;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  bool isPhoneValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isPhoneValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(context, ConstColors.lightWrongInputField, ConstColors.darkWrongInputField);
    return RepaintBoundary(
      child: Padding(
        padding: widget.padding,
        child: TextFormField(
          controller: widget.phoneController,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontSize: 17.spMin,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            prefixIcon: ImageIcon(
              const AssetImage(ConstImages.phoneIcon),
              color: color,
            ),
            label: Text(
              widget.label,
              style: const TextStyle().copyWith(color: color),
            ),
          ),
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumber],
          keyboardType: TextInputType.phone,
          validator: _validatePhone,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }

  String? _validatePhone(final String? value) {
    final String? res = Validator.validatePhoneNumber(context, value);
    if ((res == null) != isPhoneValid) {
      setState(() => isPhoneValid = !isPhoneValid);
    }
    return res;
  }
}
