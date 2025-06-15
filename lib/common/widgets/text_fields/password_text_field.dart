import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.label,
    this.padding = ConstConfig.textFieldPadding,
    required this.passwordController,
    this.checkValidator = true,
    this.textInputAction = TextInputAction.next,
    this.passwordFocusNode,
  });

  final EdgeInsetsGeometry padding;
  final String label;
  final TextEditingController passwordController;
  final TextInputAction? textInputAction;
  final bool checkValidator;
  final FocusNode? passwordFocusNode;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordValid = true;
  bool isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = isPasswordValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(context, ConstColors.lightWrongInputField, ConstColors.darkWrongInputField);

    return Padding(
      padding: widget.padding,
      child: TextFormField(
        controller: widget.passwordController,
        focusNode: widget.passwordFocusNode,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontSize: 17.spMin,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: ImageIcon(
            const AssetImage(ConstImages.passwordIcon),
            color: color,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscure ? Icons.visibility_off : Icons.visibility,
              size: 28.spMin,
              color: color,
            ),
            onPressed: _onPasswordVisibilityToggle,
          ),
          label: Text(widget.label, style: const TextStyle().copyWith(color: color)),
        ),
        textInputAction: widget.textInputAction,
        keyboardType: TextInputType.visiblePassword,
        autofillHints: const [AutofillHints.password],
        obscureText: isPasswordObscure,
        validator: widget.checkValidator ? _passwordValidator : _loginPasswordValidator,
      ),
    );
  }

  String? _passwordValidator(final String? value) {
    final String? res = Validator.validatePassword(context, value);
    if ((res == null) != isPasswordValid) {
      setState(() => isPasswordValid = !isPasswordValid);
    }
    return res;
  }

  String? _loginPasswordValidator(final String? value) {
    final String? res = Validator.validateLoginPassword(context, value);
    if ((res == null) != isPasswordValid) {
      setState(() => isPasswordValid = !isPasswordValid);
    }
    return res;
  }

  void _onPasswordVisibilityToggle() {
    setState(() => isPasswordObscure = !isPasswordObscure);
  }
}
