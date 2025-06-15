import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/core/utils/validators/validation.dart';
import 'package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart';

class OTPWidget extends StatelessWidget {
  const OTPWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final forgetPasswordCubit = context.read<ForgetPasswordCubit>();

    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => RepaintBoundary(
                child: OTPDigitField(
                  idx: index,
                  controller: forgetPasswordCubit.otpFieldControllers[index],
                  focusNode: forgetPasswordCubit.otpFieldFocusNodes[index],
                  nextFocusNode:
                      index < 3 ? forgetPasswordCubit.otpFieldFocusNodes[index + 1] : null,
                  prevFocusNode:
                      index > 0 ? forgetPasswordCubit.otpFieldFocusNodes[index - 1] : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class OTPDigitField extends StatelessWidget {
  const OTPDigitField({
    super.key,
    required this.idx,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    this.prevFocusNode,
  });

  final int idx;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? prevFocusNode;

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 50,
      height: 60,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          // if (event is! KeyDownEvent) return;
          if (event.logicalKey != LogicalKeyboardKey.backspace) return;
          if (controller.text.isNotEmpty) return;
          if (prevFocusNode == null) return;
          FocusScope.of(context).requestFocus(prevFocusNode);
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          autovalidateMode: forgetPasswordCubit.hasError[idx]
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          style: theme.textTheme.titleLarge?.copyWith(color: ConstColors.linkColor),
          showCursor: false,
          enableInteractiveSelection: false,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
          // maxLength: 1,
          decoration: buildInputDecoration(context),

          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) {
            if (value.isEmpty) return;
            if (value.length > 1) {
              value = value.substring(value.length - 1);
            }
            controller.text = value;
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus();
              Future.delayed(const Duration(milliseconds: 200), forgetPasswordCubit.checkOtp);
            }
          },

          validator: (value) {
            final String? res = Validator.validateOTPField(context, value);
            forgetPasswordCubit.setHasError(idx, res != null);
            return res;
          },
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    final Color errorBorderColor = getColor(
      context,
      ConstColors.lightWrongInputField,
      ConstColors.darkWrongInputField,
    );

    return InputDecoration(
      counterText: '',
      contentPadding: const EdgeInsets.all(0),
      // isDense: true,
      // constraints: const BoxConstraints(minWidth: 50, minHeight: 50),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: ConstColors.linkColor, width: 1.5),
        borderRadius: ConstConfig.borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ConstColors.linkColor, width: 1.5),
        borderRadius: ConstConfig.borderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: ConstColors.linkColor, width: 3.0),
        borderRadius: ConstConfig.borderRadius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorBorderColor, width: 1.5),
        borderRadius: ConstConfig.borderRadius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorBorderColor, width: 3.0),
        borderRadius: ConstConfig.borderRadius,
      ),
      errorStyle: const TextStyle(height: 0, fontSize: 0),
      errorMaxLines: 1,
    );
  }
}
