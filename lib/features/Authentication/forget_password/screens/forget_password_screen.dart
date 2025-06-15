import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:sakeny/common/widgets/custom_scaffold.dart";
import "package:sakeny/common/widgets/text_fields/email_text_field.dart";
import "package:sakeny/common/widgets/top_bar_language.dart";
import "package:sakeny/core/constants/const_config.dart";
import "package:sakeny/core/constants/const_images.dart";
import "package:sakeny/core/constants/const_text.dart";
import "package:sakeny/core/services/overlays/toastification_service.dart";
import "package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart";
import "package:sakeny/generated/l10n.dart";

part 'widget/forget_password_body_comp.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();

    return CustomScaffold(
      body: Form(
        key: forgetPasswordCubit.forgetPasswordFormKey,
        child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordEmailSuccess) {
              forgetPasswordCubit.goToForgetPasswordVerification(context);
            } else if (state is ForgetPasswordEmailFailure) {
              ToastificationService.showErrorToast(context, state.error);
            }
          },
          child: const SingleChildScrollView(
            physics: ConstConfig.scrollPhysics,
            padding: ConstConfig.screenPadding,
            child: _ForgetPasswordBody(),
          ),
        ),
      ),
    );
  }
}

class _ForgetPasswordBody extends StatelessWidget {
  const _ForgetPasswordBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TopBar(),
        SizedBox(height: 60),
        _Image(),
        _Text(),
        SizedBox(height: 30),
        _Email(),
        SizedBox(height: 20),
        _SendButton(),
      ],
    );
  }
}
