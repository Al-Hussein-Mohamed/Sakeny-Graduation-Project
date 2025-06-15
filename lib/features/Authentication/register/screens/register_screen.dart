import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_pop_scope.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/text_fields/email_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/name_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/password_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/phone_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/select_location.dart';
import 'package:sakeny/common/widgets/top_bar_language.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/features/Authentication/register/controllers/register_cubit.dart';
import 'package:sakeny/features/Authentication/register/screens/widgets/profile_picture.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:toastification/toastification.dart';

part 'widgets/register_body_comp.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterCubit registerCubit = context.read<RegisterCubit>();
    final S lang = S.of(context);

    return CustomPopScope(
      nextRoute: PageRouteNames.login,
      child: CustomScaffold(
        body: Form(
          key: registerCubit.formKey,
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                ToastificationService.showGlobalToast(
                  lang.toastRegistrationSuccessTitle,
                  lang.toastRegistrationSuccessMessage,
                  ToastificationType.success,
                );
                registerCubit.goToLogin(context, sendData: true);
              } else if (state is RegisterFailed) {
                ToastificationService.showToast(
                  context,
                  ToastificationType.error,
                  lang.error,
                  state.errorMessage,
                );
              }
            },
            child: const SingleChildScrollView(
              physics: ConstConfig.scrollPhysics,
              padding: ConstConfig.screenPadding,
              child: _RegisterBody(),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  const _RegisterBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _TopBar(),
        SizedBox(height: 30),
        _ProfilePicture(),
        SizedBox(height: 10),
        _Text(),
        SizedBox(height: 20),
        _FirstName(),
        SizedBox(height: 20),
        _SecondName(),
        SizedBox(height: 20),
        _PhoneNumber(),
        SizedBox(height: 20),
        _Email(),
        SizedBox(height: 20),
        _Password(),
        SizedBox(height: 20),
        _ConfirmPassword(),
        SizedBox(height: 20),
        _Location(),
        SizedBox(height: 20),
        _RegisterButton(),
      ],
    );
  }
}
