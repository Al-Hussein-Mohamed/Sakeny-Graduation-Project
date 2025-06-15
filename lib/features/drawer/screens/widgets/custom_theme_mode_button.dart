import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/core/constants/const_images.dart';
import 'package:sakeny/core/providers/settings_provider.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';

class CustomThemeModeButton extends StatefulWidget {
  const CustomThemeModeButton({super.key});

  @override
  State<CustomThemeModeButton> createState() => _CustomThemeModeButtonState();
}

class _CustomThemeModeButtonState extends State<CustomThemeModeButton> {
  int isDarkMode = 0;

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    isDarkMode = settings.isDarkMode ? 1 : 0;

    return Transform.scale(
      scale: 0.75,
      alignment: settings.isEn ? Alignment.centerRight : Alignment.centerLeft,
      child: Material(
        elevation: 5,
        color: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(30),
          ),
          child: AnimatedToggleSwitch<int>.rolling(
            animationCurve: Curves.linear,
            animationDuration: const Duration(milliseconds: 450),
            indicatorIconScale: 1.1,
            iconOpacity: 1.0,
            borderWidth: 4,
            height: 55,
            spacing: 4,
            loading: false,
            current: isDarkMode,
            values: const [0, 1],
            onTap: (i) {
              setState(() => isDarkMode = 1 - isDarkMode);
              settings.toggleTheme(isDarkMode);
            },
            onChanged: (i) {
              setState(() => isDarkMode = i);
              settings.toggleTheme(isDarkMode);
            },
            style: ToggleStyle(
              indicatorBoxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(1.5, 1.5),
                ),
              ],
              indicatorColor:
                  CustomColorScheme.getColor(context, CustomColorScheme.drawerThemeButtonIndicator),
              backgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
            ),
            iconBuilder: (value, _) {
              return value == 0
                  ? SvgPicture.asset(
                      ConstImages.drawerSun,
                      width: 28,
                      height: 28,
                      colorFilter: ColorFilter.mode(
                        CustomColorScheme.getColor(context, CustomColorScheme.drawerThemeButtonSun),
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      ConstImages.drawerMoon,
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(Color(0xFF253439), BlendMode.srcIn),
                    );
            },
          ),
        ),
      ),
    );
  }
}
