import 'package:flutter/material.dart';

extension DynamicTextDirectionExtension on Text {
  Align withAutomaticDirectionAlign() {
    return Align(
      alignment: _getTextDirection(data ?? '') == TextDirection.rtl
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Text(
        data ?? '',
        style: style,
        textDirection: _getTextDirection(data ?? ''),
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
      ),
    );
  }

  Text withAutomaticDirection() {
    return Text(
      data ?? '',
      style: style,
      textDirection: _getTextDirection(data ?? ''),
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

TextDirection _getTextDirection(String text) {
  if (text.isEmpty) return TextDirection.ltr;

  final RegExp arabicChars =
      RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');

  for (int i = 0; i < text.length; i++) {
    if (text[i].trim().isNotEmpty) {
      return arabicChars.hasMatch(text[i]) ? TextDirection.rtl : TextDirection.ltr;
    }
  }

  return TextDirection.ltr;
}
