import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/common/widgets/custom_scaffold.dart';
import 'package:sakeny/common/widgets/top_bar_language.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:sakeny/features/onboarding/screens/widgets/onboard_custom_page.dart';
import 'package:sakeny/features/onboarding/screens/widgets/onboarding_button.dart';
import 'package:sakeny/features/onboarding/screens/widgets/onboarding_dot_navigation.dart';

part 'widgets/onboarding_body_comp.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: ConstConfig.screenVerticalPadding),
        _TopBar(),
        _PageView(),
        _OnboardingDots(),
        _OnboardingButton(),
        SizedBox(height: ConstConfig.screenVerticalPadding),
      ],
    );
  }
}
