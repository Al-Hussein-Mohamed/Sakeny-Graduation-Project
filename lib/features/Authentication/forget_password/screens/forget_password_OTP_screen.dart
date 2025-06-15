import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/top_bar_language.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/constants/const_text.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart';
import 'package:sakeny/features/Authentication/forget_password/screens/widget/OTP_widget.dart';
import 'package:sakeny/features/Authentication/forget_password/screens/widget/resend_OTP_timer.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'widget/forget_password_OTP_body_comp.dart';

class ForgetPasswordOTPScreen extends StatelessWidget {
  const ForgetPasswordOTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);
    return CustomScaffold(
      body: Form(
        key: forgetPasswordCubit.forgetPasswordOTPFormKey,
        child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordOtpSuccess) {
              forgetPasswordCubit.goToChangePassword(context);
            } else if (state is ForgetPasswordOtpFailure) {
              ToastificationService.showErrorToast(context, state.error);
            } else if (state is ForgetPasswordResendOtpSuccess) {
              ToastificationService.showToast(
                context,
                ToastificationType.success,
                lang.toastOtpSendSuccessTitle,
                lang.toastOtpSendSuccessMessage,
              );
            }
          },
          child: const SingleChildScrollView(
            physics: ConstConfig.scrollPhysics,
            padding: ConstConfig.screenPadding,
            child: _ForgetPasswordOTPBody(),
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordOTPBody extends StatelessWidget {
  const _ForgetPasswordOTPBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TopBar(),
        SizedBox(height: 60),
        _Image(),
        _Text(),
        SizedBox(height: 30),
        _OTP(),
        SizedBox(height: 30),
        _VerifyButton(),
        SizedBox(height: 10),
        _ResendOTPTimer(),
      ],
    );
  }
}
