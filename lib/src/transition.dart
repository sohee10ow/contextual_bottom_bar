// lib/src/transition.dart

import 'package:flutter/widgets.dart';
import 'enums.dart';

class ContextualBarTransition {
  const ContextualBarTransition({
    this.preset = ContextualBarTransitionPreset.fade,
    this.duration = const Duration(milliseconds: 220),
    this.slideDirection = ContextualBarSlideDirection.rtl,
  });

  final ContextualBarTransitionPreset preset;
  final Duration duration;
  final ContextualBarSlideDirection slideDirection;

  Widget buildAnimatedSwitcher({
    required Widget child,
    required bool reverseForExit,
    Key? switcherKey,
  }) {
    return AnimatedSwitcher(
      key: switcherKey,
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (widget, animation) {
        final fade = FadeTransition(opacity: animation, child: widget);

        if (preset == ContextualBarTransitionPreset.fade) {
          return fade;
        }

        final offset = _slideOffset(reverseForExit: reverseForExit);
        final slide = SlideTransition(
          position:
              Tween<Offset>(begin: offset, end: Offset.zero).animate(animation),
          child: widget,
        );

        if (preset == ContextualBarTransitionPreset.slide) {
          return slide;
        }

        // fadeSlide
        return FadeTransition(
          opacity: animation,
          child: slide,
        );
      },
      child: child,
    );
  }

  Offset _slideOffset({required bool reverseForExit}) {
    // We reverse direction on exit per our design.
    final dir = reverseForExit ? _invert(slideDirection) : slideDirection;

    return switch (dir) {
      ContextualBarSlideDirection.rtl => const Offset(1, 0),
      ContextualBarSlideDirection.ltr => const Offset(-1, 0),
      ContextualBarSlideDirection.up => const Offset(0, 1),
    };
  }

  ContextualBarSlideDirection _invert(ContextualBarSlideDirection d) {
    return switch (d) {
      ContextualBarSlideDirection.rtl => ContextualBarSlideDirection.ltr,
      ContextualBarSlideDirection.ltr => ContextualBarSlideDirection.rtl,
      ContextualBarSlideDirection.up => ContextualBarSlideDirection.up,
    };
  }
}
