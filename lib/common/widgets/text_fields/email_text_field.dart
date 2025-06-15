import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';
import 'package:sakeny/generated/l10n.dart';

class EmailTextField extends StatefulWidget {
  const EmailTextField({
    super.key,
    this.padding = ConstConfig.textFieldPadding,
    required this.emailController,
    this.emailFocusNode,
    this.enabled = true,
  });

  final EdgeInsetsGeometry padding;
  final TextEditingController emailController;
  final FocusNode? emailFocusNode;
  final bool enabled;

  @override
  State<EmailTextField> createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
  bool _isEmailValid = true;

  // bool _hasUserInteracted = false;

  // void _validateEmailLive() {
  //   final str = widget.emailController.text;
  //
  //   if (!_hasUserInteracted && str.isNotEmpty) {
  //     _hasUserInteracted = true;
  //   }
  //
  //   if (!_hasUserInteracted) return;
  //
  //   final curValid = Validator.validateEmail(str) == null;
  //   if (curValid == _isEmailValid) return;
  //   setState(() => _isEmailValid = curValid);
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   widget.emailController.addListener(_validateEmailLive);
  // }
  //
  // @override
  // void dispose() {
  //   widget.emailController.removeListener(_validateEmailLive);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    final Color color = _isEmailValid
        ? getColor(context, ConstColors.lightInputField, Colors.white)
        : getColor(context, ConstColors.lightWrongInputField, ConstColors.darkWrongInputField);
    return Padding(
      padding: widget.padding,
      child: TextFormField(
        enabled: widget.enabled,
        controller: widget.emailController,
        focusNode: widget.emailFocusNode,
        // autovalidateMode: AutovalidateMode.onUnfocus,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: widget.enabled ? color : Colors.grey,
          fontSize: 17.spMin,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: ImageIcon(
            const AssetImage(ConstImages.emailIcon),
            color: color,
          ),
          label: Text(
            lang.email,
            style: const TextStyle().copyWith(color: color),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.email],
        validator: _validateEmail,
      ),
    );
  }

  String? _validateEmail(final String? value) {
    final String? res = Validator.validateEmail(context, value);
    if ((res == null) != _isEmailValid) {
      setState(() => _isEmailValid = !_isEmailValid);
    }
    return res;
  }
}
