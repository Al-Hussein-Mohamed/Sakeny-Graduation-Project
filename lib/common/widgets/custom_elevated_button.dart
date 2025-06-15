import 'package:flutter/material.dart';
import 'package:sakeny/core/theme/widget_themes/custom_color_scheme.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.isPrimary = true,
    this.onPressed,
    this.child,
    this.style = const ButtonStyle(),
  });

  final bool isPrimary;
  final void Function()? onPressed;
  final Widget? child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final finalButtonStyle = style?.copyWith(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.disabled)) {
          return isPrimary
              ? CustomColorScheme.getColor(
                  context, CustomColorScheme.primaryElevatedButtonDisabledBackground)
              : CustomColorScheme.getColor(
                  context, CustomColorScheme.secondaryElevatedButtonDisabledBackground);
        }
        return isPrimary
            ? CustomColorScheme.getColor(context, CustomColorScheme.primaryElevatedButtonBackground)
            : CustomColorScheme.getColor(
                context, CustomColorScheme.secondaryElevatedButtonBackground);
      }),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: finalButtonStyle,
      child: child,
    );
  }
}
