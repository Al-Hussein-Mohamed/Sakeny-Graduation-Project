import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/theme.dart';

/// A widget that automatically detects Arabic and Latin text and applies the appropriate font
class BilingualText extends StatelessWidget {
  const BilingualText({
    super.key,
    required this.text,
    this.baseStyle,
  });

  final String text;
  final TextStyle? baseStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = baseStyle ?? theme.textTheme.bodyMedium;
    final spans = _createTextSpans(text, style);

    return RichText(text: TextSpan(children: spans));
  }

  List<TextSpan> _createTextSpans(String text, TextStyle? baseStyle) {
    // Split text by spaces to process word by word
    final words = text.split(' ');
    final spans = <TextSpan>[];

    for (int i = 0; i < words.length; i++) {
      final word = words[i];
      // Check if this word contains Arabic characters
      final isArabic = _containsArabic(word);

      spans.add(
        TextSpan(
          text: '$word${i < words.length - 1 ? ' ' : ''}',
          style: baseStyle?.copyWith(
            fontFamily: isArabic ? 'Cairo' : 'Lato',
            // Apply height adjustment for Arabic text to match the line height of Latin text
            height: isArabic
                ? AppTheme.arabicFontHeight
                : 1.0, // Adjust these values based on actual measurements
          ),
        ),
      );
    }

    return spans;
  }

  bool _containsArabic(String text) {
    // Arabic Unicode block ranges from 0x0600 to 0x06FF
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }
}
