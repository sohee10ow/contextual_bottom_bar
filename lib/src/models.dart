// lib/src/models.dart

import 'package:flutter/widgets.dart';

/// A single item displayed in the bottom bar.
///
/// [id] should be stable and comparable (e.g. enum/string/int).
class ContextualBarItem {
  const ContextualBarItem({
    required this.id,
    required this.label,
    required this.unselectedWidget,
    Widget? selectedWidget,
    this.semanticsLabel,
  }) : selectedWidget = selectedWidget ?? unselectedWidget;

  /// Stable identifier for analytics/testing/routing decisions.
  final Object id;

  /// Widget shown when this item is selected.
  final Widget selectedWidget;

  /// Widget shown when this item is not selected.
  final Widget unselectedWidget;

  /// Label text shown under/near the icon depending on label visibility settings.
  final String label;

  /// Optional accessibility label overriding [label].
  final String? semanticsLabel;
}
