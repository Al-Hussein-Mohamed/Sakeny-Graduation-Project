import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/features/onboarding/controllers/onboarding_cubit.dart';
import 'package:sakeny/generated/l10n.dart';

class OnboardingButton extends StatelessWidget {
  const OnboardingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingCubit = context.read<OnboardingCubit>();
    final S lang = S.of(context);

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final bool isLastPage =
            onboardingCubit.currentPage == onboardingCubit.onboardingList.length - 1;
        final Color buttonColor = isLastPage
            ? ConstColors.secondaryColor
            : getColor(context, ConstColors.primaryColor, ConstColors.darkPrimary);
        final String buttonText =
            isLastPage ? lang.onboardingButtonText2 : lang.onboardingButtonText1;

        return Hero(
          tag: ConstConfig.authButtonTag,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                onPressed:
                    isLastPage ? () => onboardingCubit.exit(context) : onboardingCubit.nextPage,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
          ),
        );
      },
    );
  }
}
