import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/theme.dart';

/// Extension to create bilingual-aware TextThemes
extension BilingualTextThemeExtension on TextTheme {
  /// Creates a copy of this TextTheme that applies appropriate fonts to Arabic and Latin text
  TextTheme get bilingual => copyWith(
        displayLarge: displayLarge?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        displayMedium: displayMedium?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        displaySmall: displaySmall?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        headlineLarge: headlineLarge?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        headlineMedium: headlineMedium?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        headlineSmall: headlineSmall?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        titleLarge: titleLarge?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        titleMedium: titleMedium?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        titleSmall: titleSmall?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        bodyLarge: bodyLarge?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        bodyMedium: bodyMedium?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        bodySmall: bodySmall?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        labelLarge: labelLarge?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        labelMedium: labelMedium?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
        labelSmall: labelSmall?.apply(fontFamily: null, fontFamilyFallback: _fontFallbacks),
      );

  // Latin font comes first, Arabic font second in the fallback list
  static const List<String> _fontFallbacks = ['Lato', 'Cairo'];
}

/// CustomTextStyle factory to create bilingual text styles
class BilingualTextStyle {
  /// Creates a TextStyle that automatically applies the appropriate font
  /// based on the language of the text
  static TextStyle createStyle(TextStyle? baseStyle, String text) {
    bool containsArabic = _containsArabic(text);

    return (baseStyle ?? const TextStyle()).copyWith(
      fontFamily: containsArabic ? 'Cairo' : 'Lato',
      // Apply a height adjustment to normalize the Arabic font's taller appearance
      height: containsArabic ? AppTheme.arabicFontHeight : 1.0, // Adjust these values as needed
    );
  }

  static bool _containsArabic(String text) {
    // Arabic Unicode block ranges from 0x0600 to 0x06FF
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}

/// Extension method for Text widgets to automatically apply bilingual styles
extension BilingualTextExtension on Text {
  /// Creates a copy of this Text widget with bilingual font support
  Text bilingual() {
    final String textContent = data ?? '';
    final TextStyle? currentStyle = style;

    return Text(
      textContent,
      style: BilingualTextStyle.createStyle(currentStyle, textContent),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
