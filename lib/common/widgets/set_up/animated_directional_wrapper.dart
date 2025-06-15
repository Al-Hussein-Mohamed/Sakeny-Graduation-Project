import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakeny/core/providers/settings_provider.dart';

class AnimatedDirectionalWrapper extends StatefulWidget {
  const AnimatedDirectionalWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<AnimatedDirectionalWrapper> createState() => _AnimatedDirectionalWrapperState();
}

class _AnimatedDirectionalWrapperState extends State<AnimatedDirectionalWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String? _previousLanguage;
  bool _isFirstBuild = true;

  // Choose one animation effect to implement:
  final _animationType = AnimationType.blur;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
      value: 1.0,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currentLanguage = settingsProvider.currentLanguage;

    if (!_isFirstBuild && _previousLanguage != null && _previousLanguage != currentLanguage) {
      _controller
        ..reset()
        ..forward();
    }

    if (_isFirstBuild) {
      _isFirstBuild = false;
    }

    _previousLanguage = currentLanguage;

    return Directionality(
      textDirection:
          settingsProvider.currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          switch (_animationType) {
            case AnimationType.blur:
              return Stack(
                alignment: Alignment.center, // Using non-directional alignment
                children: [
                  child!,
                  if (_controller.value < 1.0)
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8.0 * (1.0 - _controller.value),
                          sigmaY: 8.0 * (1.0 - _controller.value),
                        ),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                ],
              );

            case AnimationType.scale:
              return ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(_animation),
                child: child,
              );

            case AnimationType.rotation:
              return RotationTransition(
                turns: Tween<double>(
                  begin: currentLanguage == 'ar' ? -0.02 : 0.02,
                  end: 0.0,
                ).animate(_animation),
                child: child,
              );

            case AnimationType.flip:
              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final value = _animation.value;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(3.14159 * (1 - value)),
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: value >= 0.5 ? 1.0 : 0.0,
                      child: child,
                    ),
                  );
                },
                child: child,
              );

            case AnimationType.shake:
              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  // Calculate a decreasing offset as the animation progresses
                  final progress = _animation.value;
                  final shakeOffset = sin(progress * 10 * 3.14159) * 10.0 * (1.0 - progress);

                  return Transform.translate(
                    offset: Offset(shakeOffset, 0),
                    child: child,
                  );
                },
                child: child,
              );
          }
        },
        child: widget.child,
      ),
    );
  }
}

enum AnimationType {
  blur,
  scale,
  rotation,
  flip,
  shake,
}
