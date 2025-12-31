// lib/src/contextual_bottom_bar.dart

import 'package:flutter/material.dart';

import 'enums.dart';
import 'models.dart';
import 'style.dart';
import 'transition.dart';

/// A bottom bar that can switch between a global bar and a section-specific bar.
///
/// Typical usage:
/// - `mode == ContextualBarMode.global`: show [globalItems] and use [globalIndex]
/// - `mode == ContextualBarMode.section`: show [sectionItems] and use [sectionIndex]
///
/// When an item is tapped, [onTap] is called with `(mode, index, item.id)`.
class ContextualBottomBar<K> extends StatelessWidget {
  const ContextualBottomBar({
    super.key,
    required this.mode,
    required this.sectionId,
    required this.globalIndex,
    required this.sectionIndex,
    required this.globalItems,
    required this.sectionItems,
    required this.onTap,
    this.sectionLeading,
    this.leadingWidth = 56,
    this.reserveLeadingSpace = false,
    this.height = 56,
    this.useSafeArea = true,
    this.labelVisibility = ContextualBarLabelVisibility.always,
    this.style = const ContextualBarStyle(),
    this.transition = const ContextualBarTransition(),
    this.ignoreInputDuringTransition = true,
    this.disableMaterialInkEffects = true,
    this.surfaceBuilder,
  });

  final ContextualBarMode mode;
  final K sectionId;

  final int globalIndex;
  final int sectionIndex;

  final List<ContextualBarItem> globalItems;
  final List<ContextualBarItem> sectionItems;

  final void Function(ContextualBarMode mode, int index, Object id) onTap;

  final Widget? sectionLeading;
  final double leadingWidth;
  final bool reserveLeadingSpace;

  final double height;
  final bool useSafeArea;

  final ContextualBarLabelVisibility labelVisibility;
  final ContextualBarStyle style;
  final ContextualBarTransition transition;

  final bool ignoreInputDuringTransition;

  /// When true (default), disables Material splash/highlight effects for any
  /// Material widgets placed inside the bar (e.g. [IconButton] in
  /// [sectionLeading]).
  final bool disableMaterialInkEffects;

  final Widget Function(
          BuildContext context, ContextualBarMode mode, Widget child)?
      surfaceBuilder;

  @override
  Widget build(BuildContext context) {
    final isSection = mode == ContextualBarMode.section;

    final items = isSection ? sectionItems : globalItems;
    final selectedIndexRaw = isSection ? sectionIndex : globalIndex;
    final selectedIndex = _safeSelectedIndex(selectedIndexRaw, items.length);

    assert(
      items.isEmpty ||
          (selectedIndexRaw >= 0 && selectedIndexRaw < items.length),
      'Selected index out of range. mode=$mode, index=$selectedIndexRaw, items=${items.length}',
    );

    final content = Padding(
      padding: style.padding,
      child: _buildRow(
        context: context,
        isSection: isSection,
        items: items,
        selectedIndex: selectedIndex,
      ),
    );

    Widget defaultSurfaceBuilder(
      BuildContext context,
      ContextualBarMode mode,
      Widget child,
    ) {
      final bar = Container(
        height: height,
        color: style.backgroundColor,
        child: child,
      );
      return useSafeArea ? SafeArea(top: false, child: bar) : bar;
    }

    final surfaced =
        (surfaceBuilder ?? defaultSurfaceBuilder)(context, mode, content);

    final inkEffectHandled = disableMaterialInkEffects
        ? _NoMaterialInkEffects(child: surfaced)
        : surfaced;

    // Key ensures AnimatedSwitcher recognizes bar changes by mode + sectionId.
    final childKey = ValueKey<String>('${mode.name}:${sectionId.toString()}');

    final switched = transition.buildAnimatedSwitcher(
      child: KeyedSubtree(key: childKey, child: inkEffectHandled),
      reverseForExit: mode == ContextualBarMode.global,
    );

    // Input blocking during transition (default true).
    return ignoreInputDuringTransition
        ? _InputBlocker(
            duration: transition.duration,
            trigger: '${mode.name}:${sectionId.toString()}',
            child: switched,
          )
        : switched;
  }

  int _safeSelectedIndex(int raw, int length) {
    if (length <= 0) return 0;
    if (raw >= 0 && raw < length) return raw;
    return 0;
  }

  Widget _buildRow({
    required BuildContext context,
    required bool isSection,
    required List<ContextualBarItem> items,
    required int selectedIndex,
  }) {
    final leading = isSection ? sectionLeading : null;
    final hasLeading = leading != null;
    final reserve = isSection && reserveLeadingSpace;
    final showLeadingSlot = isSection && (hasLeading || reserve);

    return Row(
      children: [
        if (showLeadingSlot)
          SizedBox(
            width: leadingWidth,
            child: Align(
              alignment: Alignment.center,
              child: leading,
            ),
          ),
        Expanded(
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == selectedIndex;
              return Expanded(
                child: _BarItemButton(
                  selectedWidget: item.selectedWidget,
                  unselectedWidget: item.unselectedWidget,
                  label: item.label,
                  semanticsLabel: item.semanticsLabel,
                  selected: selected,
                  iconSize: style.iconSize,
                  selectedColor: style.selectedColor,
                  unselectedColor: style.unselectedColor,
                  selectedLabelStyle: style.selectedLabelStyle,
                  unselectedLabelStyle: style.unselectedLabelStyle,
                  labelVisibility: labelVisibility,
                  onTap: () => onTap(mode, i, item.id),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _NoMaterialInkEffects extends StatelessWidget {
  const _NoMaterialInkEffects({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconButtonStyle = _noOverlayStyle(theme.iconButtonTheme.style);
    final textButtonStyle = _noOverlayStyle(theme.textButtonTheme.style);
    final elevatedButtonStyle =
        _noOverlayStyle(theme.elevatedButtonTheme.style);
    final outlinedButtonStyle =
        _noOverlayStyle(theme.outlinedButtonTheme.style);
    final filledButtonStyle = _noOverlayStyle(theme.filledButtonTheme.style);
    return Theme(
      data: theme.copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        iconButtonTheme: IconButtonThemeData(style: iconButtonStyle),
        textButtonTheme: TextButtonThemeData(style: textButtonStyle),
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: elevatedButtonStyle),
        outlinedButtonTheme:
            OutlinedButtonThemeData(style: outlinedButtonStyle),
        filledButtonTheme: FilledButtonThemeData(style: filledButtonStyle),
      ),
      child: child,
    );
  }

  ButtonStyle _noOverlayStyle(ButtonStyle? base) {
    const transparent = WidgetStatePropertyAll<Color?>(Colors.transparent);
    return (base ?? const ButtonStyle()).copyWith(
      overlayColor: transparent,
      splashFactory: NoSplash.splashFactory,
    );
  }
}

class _BarItemButton extends StatelessWidget {
  const _BarItemButton({
    required this.selectedWidget,
    required this.unselectedWidget,
    required this.label,
    required this.semanticsLabel,
    required this.selected,
    required this.iconSize,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.labelVisibility,
    required this.onTap,
  });

  final Widget selectedWidget;
  final Widget unselectedWidget;
  final String label;
  final String? semanticsLabel;
  final bool selected;

  final double iconSize;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  final ContextualBarLabelVisibility labelVisibility;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveLabelStyle =
        (selected ? selectedLabelStyle : unselectedLabelStyle) ??
            const TextStyle(fontSize: 11);

    final effectiveColor = selected ? selectedColor : unselectedColor;
    final icon = selected ? selectedWidget : unselectedWidget;

    final showLabel = switch (labelVisibility) {
      ContextualBarLabelVisibility.always => true,
      ContextualBarLabelVisibility.selectedOnly =>
        true, // reserve space, toggle opacity
      ContextualBarLabelVisibility.never => false,
    };

    final labelOpacity = switch (labelVisibility) {
      ContextualBarLabelVisibility.always => 1.0,
      ContextualBarLabelVisibility.selectedOnly => (selected ? 1.0 : 0.0),
      ContextualBarLabelVisibility.never => 0.0,
    };

    final iconBox = SizedBox(
      width: iconSize,
      height: iconSize,
      child: IconTheme.merge(
        data: IconThemeData(
          size: iconSize,
          color: effectiveColor,
        ),
        child: icon,
      ),
    );

    final labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: effectiveLabelStyle.copyWith(color: effectiveColor),
    );

    return Semantics(
      label: semanticsLabel ?? label,
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconBox,
              if (showLabel) const SizedBox(height: 4),
              if (showLabel)
                Opacity(
                  opacity: labelOpacity,
                  child: labelWidget,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputBlocker extends StatefulWidget {
  const _InputBlocker({
    required this.child,
    required this.duration,
    required this.trigger,
  });

  final Widget child;
  final Duration duration;

  /// Any value that changes when a transition should start blocking input.
  final Object trigger;

  @override
  State<_InputBlocker> createState() => _InputBlockerState();
}

class _InputBlockerState extends State<_InputBlocker> {
  bool _absorbing = false;
  int _token = 0;

  @override
  void didUpdateWidget(covariant _InputBlocker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only block input when a transition is triggered (mode/section changes).
    if (oldWidget.trigger != widget.trigger ||
        oldWidget.duration != widget.duration) {
      _startBlock();
    }
  }

  void _startBlock() {
    _token++;
    final int token = _token;

    if (!_absorbing) {
      setState(() => _absorbing = true);
    }

    Future<void>.delayed(widget.duration).then((_) {
      if (!mounted) return;
      if (token != _token) return; // a newer transition started
      setState(() => _absorbing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _absorbing,
      child: widget.child,
    );
  }
}
