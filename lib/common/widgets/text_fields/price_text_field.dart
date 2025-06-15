import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class PriceTextField extends StatefulWidget {
  const PriceTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.label,
    required this.hintText,
    required this.priceController,
    this.focusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController priceController;
  final FocusNode? focusNode;
  final String hintText;

  @override
  State<PriceTextField> createState() => _PriceTextFieldState();
}

class _PriceTextFieldState extends State<PriceTextField> {
  bool isPriceValid = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isPriceValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(
            context,
            ConstColors.lightWrongInputField,
            ConstColors.darkWrongInputField,
          );

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.priceController,
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
        validator: _validatePrice,
      ),
    );
  }

  String? _validatePrice(final String? value) {
    final res = Validator.validatePrice(context, value);
    if ((res == null) != isPriceValid) {
      setState(() => isPriceValid = !isPriceValid);
    }
    return res;
  }
}
