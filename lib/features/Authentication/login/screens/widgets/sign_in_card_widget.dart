import "package:flutter/material.dart";
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/constants/const_config.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/services/service_locator.dart';
import 'package:sakeny/features/Authentication/login/models/sing_in_card_model.dart';

class SignInCardWidget extends StatelessWidget {
  const SignInCardWidget({super.key, required this.signInCardModel});

  final SignInCardModel signInCardModel;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider _settings = sl<SettingsProvider>();

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: signInCardModel.onTap,
          borderRadius: ConstConfig.borderRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: _settings.isDarkMode
                  ? ConstColors.onScaffoldBackgroundDark
                  : signInCardModel.backgroundColor,
              borderRadius: ConstConfig.borderRadius,
            ),
            child: Image.asset(
              signInCardModel.image,
              width: ConstConfig.smallIconSize,
              height: ConstConfig.smallIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
