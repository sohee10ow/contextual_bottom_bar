// lib/src/style.dart

import 'package:flutter/widgets.dart';

class ContextualBarStyle {
  const ContextualBarStyle({
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.iconSize = 24,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  });

  final Color? backgroundColor;

  /// Hint color for selected state (labels or other elements).
  final Color? selectedColor;

  /// Hint color for unselected state (labels or other elements).
  final Color? unselectedColor;

  final double iconSize;

  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  final EdgeInsets padding;
}
