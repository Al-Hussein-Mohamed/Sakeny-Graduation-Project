import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/routing/page_route_name.dart';
import 'package:sakeny/features/onboarding/models/onboarding_model.dart';
import 'package:sakeny/generated/l10n.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  List<OnboardingModel> onboardingList = [
    OnboardingModel(
      image: ConstImages.onboarding1,
      title: "onboardingTitle1",
      description: "onboardingSubTitle1",
    ),
    OnboardingModel(
      image: ConstImages.onboarding2,
      title: "onboardingTitle2",
      description: "onboardingSubTitle2",
    ),
    OnboardingModel(
      image: ConstImages.onboarding3,
      title: "onboardingTitle3",
      description: "onboardingSubTitle3",
    ),
  ];

  void setUp(BuildContext context) {
    final lang = S.of(context);
    onboardingList[0] = OnboardingModel(
      image: ConstImages.onboarding1,
      title: lang.onboardingTitle1,
      description: lang.onboardingSubTitle1,
    );
    onboardingList[1] = OnboardingModel(
      image: ConstImages.onboarding2,
      title: lang.onboardingTitle2,
      description: lang.onboardingSubTitle2,
    );
    onboardingList[2] = OnboardingModel(
      image: ConstImages.onboarding3,
      title: lang.onboardingTitle3,
      description: lang.onboardingSubTitle3,
    );
  }

  int currentPage = 0;
  final pageController = PageController();

  void changePage(int index) {
    currentPage = index;
    emit(OnboardingInitial());
  }

  void navigationChangePage(int index) async {
    await pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    currentPage = index;
    emit(OnboardingInitial());
  }

  void nextPage() async {
    if (currentPage == onboardingList.length - 1) return;
    currentPage++;
    await pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    emit(OnboardingInitial());
  }

  void exit(BuildContext context) {
    Navigator.pushReplacementNamed(context, PageRouteNames.login);
    // NavigatorAssetsPreCache.pushReplacementNamed(context, PageRouteNames.login, null);
  }
}
