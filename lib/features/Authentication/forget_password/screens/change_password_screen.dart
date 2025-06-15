import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/text_fields/password_text_field.dart';
import 'package:sakeny/common/widgets/top_bar_language.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/constants/const_text.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/Authentication/forget_password/controllers/forget_password_cubit.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'widget/change_password_screen_comp.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final ForgetPasswordCubit forgetPasswordCubit = context.read<ForgetPasswordCubit>();
    final S lang = S.of(context);
    return CustomScaffold(
      body: Form(
        key: forgetPasswordCubit.changePasswordFormKey,
        child: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              ToastificationService.showGlobalToast(
                lang.changePasswordSuccess,
                null,
                ToastificationType.success,
              );
              forgetPasswordCubit.exit(context);
            } else if (state is ChangePasswordFailure) {
              ToastificationService.showErrorToast(context, state.error);
            }
          },
          child: const SingleChildScrollView(
            physics: ConstConfig.scrollPhysics,
            padding: ConstConfig.screenPadding,
            child: _ChangePasswordBody(),
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordBody extends StatelessWidget {
  const _ChangePasswordBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TopBar(),
        SizedBox(height: 60),
        _Image(),
        _Text(),
        SizedBox(height: 30),
        _Password(),
        SizedBox(height: 20),
        _ConfirmPassword(),
        SizedBox(height: 20),
        _ChangePasswordButton(),
      ],
    );
  }
}
