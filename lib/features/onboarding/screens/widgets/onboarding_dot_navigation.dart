import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingCubit onboardingCubit = context.read<OnboardingCubit>();
    final textDirection = Directionality.of(context);
    final Color color = getColor(context, ConstColors.primaryColor, ConstColors.darkPrimary);
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Directionality(
          textDirection: textDirection,
          child: SmoothPageIndicator(
            controller: onboardingCubit.pageController,
            onDotClicked: onboardingCubit.navigationChangePage,
            count: 3,
            effect: CustomizableEffect(
              activeDotDecoration: DotDecoration(
                color: color,
                height: 20,
                width: 50,
                borderRadius: BorderRadius.circular(10),
              ),
              dotDecoration: DotDecoration(
                color: Colors.transparent,
                height: 20,
                width: 28,
                borderRadius: BorderRadius.circular(10),
                dotBorder: DotBorder(
                  color: color,
                  width: 2.2,
                ),
              ),
              spacing: 10, // Spacing between dots
            ),
          ),
        );
      },
    );
  }
}
