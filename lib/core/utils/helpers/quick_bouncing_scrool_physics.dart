import 'package:flutter/material.dart';

/// Custom scroll physics that maintains bouncing behavior but reduces the duration
/// of scrolling after the user removes their finger.
class QuickBouncingScrollPhysics extends BouncingScrollPhysics {
  const QuickBouncingScrollPhysics({super.parent});

  // @override
  // SpringDescription get spring => const SpringDescription(
  //       mass: 0.5, // Lower mass makes it stop faster
  //       stiffness: 350.0, // Higher stiffness increases responsiveness
  //       damping: 1.2, // Higher damping reduces oscillation
  //     );

  // Override method with proper signature instead of using a getter
  @override
  double frictionFactor(double overscrollFraction) {
    return 1.2; // Higher friction = faster stop
  }

// @override
// QuickBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
//   return QuickBouncingScrollPhysics(parent: buildParent(ancestor));
// }
}
