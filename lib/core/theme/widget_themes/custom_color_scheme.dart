import "package:flutter/material.dart";
import "package:sakeny/core/constants/const_colors.dart";

class CustomColorScheme {
  CustomColorScheme._();

  static final String appLogoColor = "appLogoColor";
  static final String filterSearchIcon = "filterSearchIcon";
  static final String text = "text";

  // drawer
  static final String drawerIcon = "drawerIcon";
  static final String drawerTile = "drawerText";
  static final String drawerThemeButtonIndicator = "drawerThemeButtonIndicator";
  static final String drawerThemeButtonSun = "drawerThemeButtonSun";

  // post colors
  static final String postBorder = "postBorder";
  static final String postUserBackground = "postUserBackground";
  static final String postShimmerBase = "postShimmerBase";
  static final String postShimmerHighlight = "postShimmerHighlight";

  // elevated buttons
  static final String primaryElevatedButtonBackground = "primaryElevatedButtonBackground";
  static final String primaryElevatedButtonDisabledBackground =
      "primaryElevatedButtonDisabledBackground";
  static final String secondaryElevatedButtonBackground = "secondaryElevatedButtonBackground";
  static final String secondaryElevatedButtonDisabledBackground =
      "secondaryElevatedButtonDisabledBackground";

  static ColorScheme lightColorScheme = const ColorScheme(
    brightness: Brightness.light,
    primary: ConstColors.primaryColor,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: ConstColors.primaryColor,
    surface: Colors.white,
    onSurface: ConstColors.onScaffoldBackground,
    error: ConstColors.lightWrongInputField,
    onError: Colors.white,
  ).withCustomColors({
    text: ConstColors.primaryColor,
    appLogoColor: ConstColors.primaryColor,
    drawerIcon: ConstColors.primaryColor,
    drawerTile: ConstColors.drawerTile,
    drawerThemeButtonSun: ConstColors.drawerThemeButtonSun,
    drawerThemeButtonIndicator: ConstColors.drawerThemeButtonIndicator,
    filterSearchIcon: ConstColors.primaryColor,

    // post
    postBorder: Colors.grey,
    postUserBackground: const Color(0xFFF4F4F4),
    postShimmerBase: ConstColors.postShimmerBaseColor,
    postShimmerHighlight: ConstColors.postShimmerHighLightColor,

    // elevated buttons
    primaryElevatedButtonBackground: ConstColors.primaryElevatedButtonBackground,
    primaryElevatedButtonDisabledBackground: ConstColors.primaryElevatedButtonDisabledBackground,
    secondaryElevatedButtonBackground: ConstColors.secondaryElevatedButtonBackground,
    secondaryElevatedButtonDisabledBackground:
        ConstColors.secondaryElevatedButtonDisabledBackground,
  });

  static ColorScheme darkColorScheme = const ColorScheme(
    brightness: Brightness.dark,
    primary: ConstColors.primaryColor,
    onPrimary: Colors.white,
    secondary: Colors.white,
    onSecondary: ConstColors.primaryColor,
    surface: Colors.white,
    onSurface: ConstColors.onScaffoldBackgroundDark,
    error: Colors.red,
    onError: Colors.white,
  ).withCustomColors({
    text: Colors.white,
    appLogoColor: Colors.white,
    drawerIcon: ConstColors.onScaffoldBackgroundDark,
    drawerTile: ConstColors.drawerTileDark,
    drawerThemeButtonSun: ConstColors.drawerThemeButtonSunDark,
    drawerThemeButtonIndicator: ConstColors.drawerThemeButtonIndicatorDark,
    filterSearchIcon: ConstColors.onScaffoldBackgroundDark,

    // post
    postBorder: Colors.white,
    postUserBackground: const Color(0xFF6C7D82),
    postShimmerBase: ConstColors.postShimmerBaseColorDark,
    postShimmerHighlight: ConstColors.postShimmerHighLightColorDark,

    // elevated buttons
    primaryElevatedButtonBackground: ConstColors.primaryElevatedButtonBackgroundDark,
    primaryElevatedButtonDisabledBackground:
        ConstColors.primaryElevatedButtonDisabledBackgroundDark,
    secondaryElevatedButtonBackground: ConstColors.secondaryElevatedButtonBackgroundDark,
    secondaryElevatedButtonDisabledBackground:
        ConstColors.secondaryElevatedButtonDisabledBackgroundDark,
  });

  // Helper method to easily get custom colors from ThemeData
  static Color getColor(BuildContext context, String colorKey) {
    return Theme.of(context).colorScheme.getCustomColor(colorKey);
  }
}

final Map<Brightness, Map<String, Color>> _themeCustomColors = {
  Brightness.light: {},
  Brightness.dark: {},
};

extension CustomColorSchemeExtension on ColorScheme {
  Color getCustomColor(String key) {
    return _themeCustomColors[brightness]?[key] ?? Colors.red;
  }

  ColorScheme withCustomColors(Map<String, Color> colors) {
    _themeCustomColors[brightness] = {
      ..._themeCustomColors[brightness] ?? {},
      ...colors,
    };
    return this;
  }

  // Add a single custom color
  ColorScheme addCustomColor(String key, Color color) {
    _themeCustomColors[brightness] ??= {};
    _themeCustomColors[brightness]![key] = color;
    return this;
  }

  // Optimized lerp between two color schemes with custom colors

  static ColorScheme lerpWithCustomColors(ColorScheme a, ColorScheme b, double t) {
    final ColorScheme result = ColorScheme.lerp(a, b, t);

    // Only perform lerp if schemes have different brightness
    if (a.brightness != b.brightness) {
      final allKeys = {
        ..._themeCustomColors[a.brightness]?.keys ?? {},
        ..._themeCustomColors[b.brightness]?.keys ?? {},
      };

      final Map<String, Color> lerpedColors = {};
      for (final String key in allKeys) {
        final Color colorA = a.getCustomColor(key);
        final Color colorB = b.getCustomColor(key);
        lerpedColors[key] = Color.lerp(colorA, colorB, t) ?? Colors.transparent;
      }

      // Use resultant brightness to store lerped colors
      _themeCustomColors[result.brightness] = {
        ..._themeCustomColors[result.brightness] ?? {},
        ...lerpedColors,
      };
    }

    return result;
  }

  // Improved copy with custom colors
  ColorScheme copyWithCustomColors({Map<String, Color>? customColors}) {
    final Map<String, Color> currentColors = _themeCustomColors[brightness] ?? {};
    final Map<String, Color> newColors = customColors ?? {};
    return copyWith().withCustomColors({...currentColors, ...newColors});
  }

  static ColorScheme lerp(ColorScheme a, ColorScheme b, double t) {
    print("lerp!!!!!!!!!!!!!");
    if (identical(a, b)) {
      return a;
    }

    // Create the base lerp result
    final ColorScheme result = ColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t),
      onPrimaryContainer: Color.lerp(a.onPrimaryContainer, b.onPrimaryContainer, t),
      primaryFixed: Color.lerp(a.primaryFixed, b.primaryFixed, t),
      primaryFixedDim: Color.lerp(a.primaryFixedDim, b.primaryFixedDim, t),
      onPrimaryFixed: Color.lerp(a.onPrimaryFixed, b.onPrimaryFixed, t),
      onPrimaryFixedVariant: Color.lerp(a.onPrimaryFixedVariant, b.onPrimaryFixedVariant, t),
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
      secondaryContainer: Color.lerp(a.secondaryContainer, b.secondaryContainer, t),
      onSecondaryContainer: Color.lerp(a.onSecondaryContainer, b.onSecondaryContainer, t),
      secondaryFixed: Color.lerp(a.secondaryFixed, b.secondaryFixed, t),
      secondaryFixedDim: Color.lerp(a.secondaryFixedDim, b.secondaryFixedDim, t),
      onSecondaryFixed: Color.lerp(a.onSecondaryFixed, b.onSecondaryFixed, t),
      onSecondaryFixedVariant: Color.lerp(a.onSecondaryFixedVariant, b.onSecondaryFixedVariant, t),
      tertiary: Color.lerp(a.tertiary, b.tertiary, t),
      onTertiary: Color.lerp(a.onTertiary, b.onTertiary, t),
      tertiaryContainer: Color.lerp(a.tertiaryContainer, b.tertiaryContainer, t),
      onTertiaryContainer: Color.lerp(a.onTertiaryContainer, b.onTertiaryContainer, t),
      tertiaryFixed: Color.lerp(a.tertiaryFixed, b.tertiaryFixed, t),
      tertiaryFixedDim: Color.lerp(a.tertiaryFixedDim, b.tertiaryFixedDim, t),
      onTertiaryFixed: Color.lerp(a.onTertiaryFixed, b.onTertiaryFixed, t),
      onTertiaryFixedVariant: Color.lerp(a.onTertiaryFixedVariant, b.onTertiaryFixedVariant, t),
      error: Color.lerp(a.error, b.error, t)!,
      onError: Color.lerp(a.onError, b.onError, t)!,
      errorContainer: Color.lerp(a.errorContainer, b.errorContainer, t),
      onErrorContainer: Color.lerp(a.onErrorContainer, b.onErrorContainer, t),
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      surfaceDim: Color.lerp(a.surfaceDim, b.surfaceDim, t),
      surfaceBright: Color.lerp(a.surfaceBright, b.surfaceBright, t),
      surfaceContainerLowest: Color.lerp(a.surfaceContainerLowest, b.surfaceContainerLowest, t),
      surfaceContainerLow: Color.lerp(a.surfaceContainerLow, b.surfaceContainerLow, t),
      surfaceContainer: Color.lerp(a.surfaceContainer, b.surfaceContainer, t),
      surfaceContainerHigh: Color.lerp(a.surfaceContainerHigh, b.surfaceContainerHigh, t),
      surfaceContainerHighest: Color.lerp(a.surfaceContainerHighest, b.surfaceContainerHighest, t),
      onSurfaceVariant: Color.lerp(a.onSurfaceVariant, b.onSurfaceVariant, t),
      outline: Color.lerp(a.outline, b.outline, t),
      outlineVariant: Color.lerp(a.outlineVariant, b.outlineVariant, t),
      shadow: Color.lerp(a.shadow, b.shadow, t),
      scrim: Color.lerp(a.scrim, b.scrim, t),
      inverseSurface: Color.lerp(a.inverseSurface, b.inverseSurface, t),
      onInverseSurface: Color.lerp(a.onInverseSurface, b.onInverseSurface, t),
      inversePrimary: Color.lerp(a.inversePrimary, b.inversePrimary, t),
      surfaceTint: Color.lerp(a.surfaceTint, b.surfaceTint, t),
      // DEPRECATED (newest deprecations at the bottom)
      background: Color.lerp(a.background, b.background, t),
      onBackground: Color.lerp(a.onBackground, b.onBackground, t),
      surfaceVariant: Color.lerp(a.surfaceVariant, b.surfaceVariant, t),
    );

    // Handle custom colors
    if (a.brightness != b.brightness) {
      final allKeys = {
        ..._themeCustomColors[a.brightness]?.keys ?? {},
        ..._themeCustomColors[b.brightness]?.keys ?? {},
      };

      final Map<String, Color> lerpedColors = {};
      for (final String key in allKeys) {
        final Color colorA = a.getCustomColor(key);
        final Color colorB = b.getCustomColor(key);
        lerpedColors[key] = Color.lerp(colorA, colorB, t) ?? Colors.transparent;
      }

      // Use resultant brightness to store lerped colors
      _themeCustomColors[result.brightness] = {
        ..._themeCustomColors[result.brightness] ?? {},
        ...lerpedColors,
      };
    }

    return result;
  }
}
