# contextual_bottom_bar

[![pub package](https://img.shields.io/pub/v/contextual_bottom_bar.svg)](https://pub.dev/packages/contextual_bottom_bar)
[![likes](https://img.shields.io/pub/likes/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)
[![pub points](https://img.shields.io/pub/points/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)
[![popularity](https://img.shields.io/pub/popularity/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)

English | [한국어](README.ko.md)

A Flutter bottom navigation bar that switches between a **Global bar** and a **Section bar** (context-aware bar), like many finance / commerce apps.

![Simulator Screen Recording - iPhone 17 Pro Max - 2025-12-31 at 14 56 17](https://github.com/user-attachments/assets/713f44c1-2955-4f75-90d6-a2068113c765)


## Why

Some apps keep a global bottom tab bar, but replace it with a contextual set of tabs when the user enters a specific section (e.g. Shopping, Stocks). This package provides that pattern as a single widget with clean APIs.

## Features

- Switch between `global` ↔ `section` modes with built-in transitions
- `ContextualBarItem` supports `selectedWidget` / `unselectedWidget` (images or any custom widget)
- Optional `sectionLeading` slot (e.g. back button)
- Label visibility: `always`, `selectedOnly`, `never`
- `surfaceBuilder` for custom rounded / shadow / blur surfaces
- `disableMaterialInkEffects` to remove ripple/highlight inside the bar (useful for custom UI)

## Install

```yaml
dependencies:
  contextual_bottom_bar: ^0.0.2
```

## Quick start

See `example/lib/main.dart` for a complete runnable demo.

```dart
ContextualBottomBar<MySectionId>(
  mode: mode,
  sectionId: sectionId,
  globalIndex: globalIndex,
  sectionIndex: sectionIndex,
  globalItems: const [
    ContextualBarItem(
      id: 'home',
      label: 'Home',
      unselectedWidget: Icon(Icons.home_outlined),
      selectedWidget: Icon(Icons.home),
    ),
    ContextualBarItem(
      id: MySectionId.ticket,
      label: 'Tickets',
      unselectedWidget: Icon(Icons.confirmation_num_outlined),
      selectedWidget: Icon(Icons.confirmation_num),
    ),
  ],
  sectionItems: mode == ContextualBarMode.section ? sectionItems : const [],
  sectionLeading: mode == ContextualBarMode.section
      ? IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        )
      : null,
  onTap: (mode, index, id) {
    // handle taps / switch mode
  },
);
```

## Notes

### Disabling ink effects (ripple/highlight)

If you pass Material widgets like `IconButton` as `sectionLeading`, you might see ripple/highlight effects. This package disables them by default:

```dart
ContextualBottomBar(
  disableMaterialInkEffects: true, // default
  // ...
)
```

### Migration (0.0.1 → 0.0.2)

`ContextualBarItem.icon` was replaced by `unselectedWidget` and optional `selectedWidget`.

```dart
// before
ContextualBarItem(id: 'home', icon: Icon(Icons.home_outlined), label: 'Home');

// after
ContextualBarItem(
  id: 'home',
  label: 'Home',
  unselectedWidget: Icon(Icons.home_outlined),
  selectedWidget: Icon(Icons.home),
);
```

## License

See `LICENSE`.
