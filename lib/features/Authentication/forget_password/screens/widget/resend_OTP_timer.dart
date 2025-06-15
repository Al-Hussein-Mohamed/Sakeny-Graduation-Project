import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class ResendOTPTimer extends StatefulWidget {
  const ResendOTPTimer({super.key});

  @override
  State<ResendOTPTimer> createState() => _ResendOTPTimerState();
}

class _ResendOTPTimerState extends State<ResendOTPTimer> {
  Timer? _timer;
  int _secondRemaining = 60;
  bool _canResend = false;

  void _startTimer() {
    _secondRemaining = 60;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          if (_secondRemaining > 0) {
            _secondRemaining--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: lang.forgetPasswordDidnotReceiveCode,
            style: theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: lang.forgetPasswordSendAgain,
                style: _canResend
                    ? theme.textTheme.bodySmall?.copyWith(color: ConstColors.linkColor)
                    : theme.textTheme.bodySmall,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => forgetPasswordCubit.resendOTP().then((value) => _startTimer()),
              ),
              TextSpan(
                text: !_canResend ? " ($_secondRemaining)" : "    ",
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
