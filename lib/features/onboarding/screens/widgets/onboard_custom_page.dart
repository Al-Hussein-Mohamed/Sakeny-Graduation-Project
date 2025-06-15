import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:sakeny/features/onboarding/models/onboarding_model.dart';

class OnboardingCustomPage extends StatelessWidget {
  const OnboardingCustomPage({super.key, required this.onboardingModel});

  final OnboardingModel onboardingModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboardingCubit = context.read<OnboardingCubit>();
    final Color backgroundColor = getColor(context, Colors.white, ConstColors.darkPrimary);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding + 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: ConstConfig.borderRadius,
              ),
              child: Image.asset(onboardingModel.image),
            ),
            const SizedBox(height: 10),
            Text(
              onboardingModel.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                shadows: [ConstConfig.shadow],
              ),
            ),
            Text(
              onboardingModel.description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
