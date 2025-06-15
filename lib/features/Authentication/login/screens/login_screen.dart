import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sakeny/common/widgets/app_logo.dart';
import 'package:sakeny/common/widgets/custom_pop_scope.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/text_fields/email_text_field.dart';
import 'package:sakeny/common/widgets/text_fields/password_text_field.dart';
import 'package:sakeny/common/widgets/top_bar_language.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/core/services/overlays/toastification_service.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/Authentication/login/controllers/login_cubit.dart';
import 'package:sakeny/features/Authentication/login/models/sing_in_card_model.dart';
import 'package:sakeny/features/Authentication/login/screens/widgets/sign_in_card_widget.dart';
import 'package:sakeny/generated/l10n.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

part 'widgets/login_body_comp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _bannerShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerShown) return;
    final route = ModalRoute.of(context);
    final Map<String, dynamic>? args = route?.settings.arguments as Map<String, dynamic>?;

    if (args == null) return;
    if (args.containsKey("showVerifyEmailBanner") == false) return;
    if (args["showVerifyEmailBanner"] == false) return;
    _bannerShown = true;
  }

  @override
  Widget build(BuildContext context) {
    final LoginCubit loginCubit = context.read<LoginCubit>();

    return CustomPopScope(
      nextRoute: PageRouteNames.onboarding,
      child: CustomScaffold(
        body: Form(
          key: loginCubit.formKey,
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  PageRouteNames.home,
                  (route) => false,
                );
              } else if (state is LoginFailed) {
                ToastificationService.showErrorToast(context, state.errorMessage);
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: ConstConfig.scrollPhysics,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const Padding(
                      padding: ConstConfig.screenPadding,
                      child: _LoginBody(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TopBar(),
        Column(
          children: [
            SizedBox(height: 12),
            _TitleWidget(),
            SizedBox(height: 30),
            _Email(),
            SizedBox(height: 20),
            _Password(),
            SizedBox(height: 5),
            _RememberMeAndForgetPassword(),
            SizedBox(height: 12),
            _LoginButton(),
            SizedBox(height: 12),
            _SignInCards(),
            SizedBox(height: 12),
            _Register(),
            SizedBox(height: 12),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _AppVersion(),
            _GuestLogin(),
          ],
        ),
      ],
    );
  }
}
