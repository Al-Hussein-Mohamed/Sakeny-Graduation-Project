import 'package:flutter/material.dart';

/// Extension on TextField for dynamic text direction
extension DynamicTextFieldDirectionExtension on TextField {
  /// Creates a TextField that automatically changes direction based on input language
  Widget withAutomaticDirection() {
    final TextEditingController controller = this.controller ?? TextEditingController();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final TextDirection direction = _detectTextDirection(value.text);

        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: decoration,
          style: style,
          textDirection: direction,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          autofocus: autofocus,
          readOnly: readOnly,
          showCursor: showCursor,
          obscuringCharacter: obscuringCharacter,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          enabled: enabled,
          // Other properties...
        );
      },
    );
  }
}

/// Detects text direction based on the first non-whitespace character
TextDirection _detectTextDirection(String text) {
  if (text.isEmpty) return TextDirection.ltr;

  // Arabic Unicode blocks
  final RegExp arabicChars =
      RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');

  // Find the first non-whitespace character
  for (int i = 0; i < text.length; i++) {
    if (text[i].trim().isNotEmpty) {
      return arabicChars.hasMatch(text[i]) ? TextDirection.rtl : TextDirection.ltr;
    }
  }

  return TextDirection.ltr;
}
