import 'package:flutter/material.dart';
import 'package:sakeny/core/constants/const_colors.dart';
import 'package:sakeny/core/utils/helpers/helpers.dart';
import 'package:sakeny/generated/l10n.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    required this.ratingCount,
    this.size = 22,
    this.color = ConstColors.ratingStars,
    this.borderColor = ConstColors.ratingStars,
    this.starCount = 5,
    this.spacing = 0,
  });

  final double rating;
  final int ratingCount;
  final double size;
  final Color color;
  final Color borderColor;
  final int starCount;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final S lang = S.of(context);
    late final List<Widget> stars = _generateStars();
    final Color textColor = getColor(context, ConstColors.primaryColor, Colors.white);

    return ratingCount == 0
        ? Text(lang.unratedUnit, style: theme.textTheme.bodySmall)
        : RepaintBoundary(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...stars,
                  const SizedBox(width: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "($ratingCount)",
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  List<Widget> _generateStars() {
    return List.generate(starCount, (index) {
      final double value = (rating - index).clamp(0, 1);
      return _StarWidget(
        key: ValueKey("${super.key}_$index"),
        value: value,
        size: size,
        color: color,
        borderColor: borderColor,
      );
    });
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RatingStars &&
        other.rating == rating &&
        other.size == size &&
        other.color == color &&
        other.borderColor == borderColor &&
        other.starCount == starCount &&
        other.spacing == spacing;
  }

  @override
  int get hashCode => Object.hash(
        rating,
        size,
        color,
        borderColor,
        starCount,
        spacing,
      );
}

class _StarWidget extends StatelessWidget {
  const _StarWidget({
    super.key,
    required this.value,
    required this.size,
    required this.color,
    required this.borderColor,
  });

  final double value;
  final double size;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    // Use constants where possible for full and empty stars
    if (value >= 0.99) {
      return Icon(Icons.star_rounded, size: size, color: color);
    } else if (value <= 0.01) {
      return Icon(Icons.star_border_rounded, size: size, color: borderColor);
    }

    // For partial stars, stack a border star with a partially filled star
    return Stack(
      alignment: Alignment.center,
      children: [
        // Bottom layer: star border
        Icon(Icons.star_border_rounded, size: size, color: borderColor),

        // Top layer: partially filled star with shader mask
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              stops: [value, value],
              colors: [color, Colors.transparent],
            ).createShader(bounds);
          },
          child: Icon(Icons.star, size: size),
        ),
      ],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _StarWidget &&
        other.value == value &&
        other.size == size &&
        other.color == color &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(value, size, color, borderColor);
}
