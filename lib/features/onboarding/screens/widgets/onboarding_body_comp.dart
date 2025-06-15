part of '../onboarding_screen.dart';

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final OnboardingCubit onboardingCubit = context.read<OnboardingCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: ConstConfig.screenHorizontalPadding),
      child: TopBarLanguage(
        icon: Icons.close,
        function: () => onboardingCubit.exit(context),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView();

  @override
  Widget build(BuildContext context) {
    final OnboardingCubit onboardingCubit = context.read<OnboardingCubit>()..setUp(context);
    return Expanded(
      flex: 4,
      child: PageView.builder(
        controller: onboardingCubit.pageController,
        onPageChanged: onboardingCubit.changePage,
        itemCount: onboardingCubit.onboardingList.length,
        itemBuilder: (context, index) =>
            OnboardingCustomPage(onboardingModel: onboardingCubit.onboardingList[index]),
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: OnboardingDotNavigation(),
      ),
    );
  }
}

class _OnboardingButton extends StatelessWidget {
  const _OnboardingButton();

  @override
  Widget build(BuildContext context) {
    return const OnboardingButton();
  }
}
