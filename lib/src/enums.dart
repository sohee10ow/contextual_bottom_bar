// lib/src/enums.dart

/// Which bar is currently visible.
enum ContextualBarMode {
  global,
  section,
}

/// How labels are displayed under icons.
enum ContextualBarLabelVisibility {
  /// Always show labels.
  always,

  /// Show label only for the selected item.
  ///
  /// Tip: For layout stability, it's recommended to reserve label space and
  /// toggle via opacity instead of removing the label widget entirely.
  selectedOnly,

  /// Never show labels (icon-only).
  never,
}

/// Built-in transition presets for switching between global/section bars.
enum ContextualBarTransitionPreset {
  fade,
  slide,
  fadeSlide,
}

/// Slide direction used by the slide presets.
enum ContextualBarSlideDirection {
  /// Right-to-left (enter from right, exit to left).
  rtl,

  /// Left-to-right (enter from left, exit to right).
  ltr,

  /// Bottom-to-top (enter from bottom, exit to top).
  up,
}
