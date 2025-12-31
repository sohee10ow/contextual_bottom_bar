# contextual_bottom_bar

[![pub package](https://img.shields.io/pub/v/contextual_bottom_bar.svg)](https://pub.dev/packages/contextual_bottom_bar)
[![likes](https://img.shields.io/pub/likes/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)
[![pub points](https://img.shields.io/pub/points/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)
[![popularity](https://img.shields.io/pub/popularity/contextual_bottom_bar)](https://pub.dev/packages/contextual_bottom_bar/score)

[English](README.md) | 한국어

금융/커머스 앱에서 자주 쓰는 패턴처럼, **Global bar**(전역 탭) ↔ **Section bar**(섹션 탭)로 전환되는 하단 바를 쉽게 구현할 수 있는 Flutter 위젯입니다.

![Uploading Simulator Screen Recording - iPhone 17 Pro Max - 2025-12-31 at 14.56.17.gif…]()


## 왜 필요한가요?

전역 탭을 유지하다가 특정 섹션(예: 쇼핑/증권)으로 들어갈 때 하단 탭 구성이 완전히 바뀌는 UX가 많습니다. 이 패키지는 그 패턴을 `ContextualBottomBar` 하나로 구성할 수 있게 해줍니다.

## 기능

- `global` ↔ `section` 모드 전환 + 기본 트랜지션 제공
- `ContextualBarItem`에 `selectedWidget` / `unselectedWidget` 지원 (이미지/커스텀 위젯 가능)
- `sectionLeading` 슬롯 지원 (예: 뒤로가기 버튼)
- 라벨 표시 옵션: `always`, `selectedOnly`, `never`
- `surfaceBuilder`로 둥근 모서리/그림자/블러 등 완전 커스텀 가능
- `disableMaterialInkEffects`로 ripple/highlight(잉크 효과) 제거 (커스텀 UI에 유용)

## 설치

```yaml
dependencies:
  contextual_bottom_bar: ^0.0.2
```

## 빠른 시작

실행 가능한 전체 예제는 `example/lib/main.dart`를 참고하세요.

```dart
ContextualBottomBar<MySectionId>(
  mode: mode,
  sectionId: sectionId,
  globalIndex: globalIndex,
  sectionIndex: sectionIndex,
  globalItems: const [
    ContextualBarItem(
      id: 'home',
      label: '홈',
      unselectedWidget: Icon(Icons.home_outlined),
      selectedWidget: Icon(Icons.home),
    ),
    ContextualBarItem(
      id: MySectionId.ticket,
      label: '티켓',
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
    // 탭 처리 / 모드 전환
  },
);
```

## 참고

### 잉크 효과(ripple/highlight) 제거

`sectionLeading` 등에 `IconButton` 같은 Material 위젯을 넣으면 ripple/highlight가 보일 수 있어요. 이 패키지는 기본적으로 잉크 효과를 꺼둡니다:

```dart
ContextualBottomBar(
  disableMaterialInkEffects: true, // 기본값
  // ...
)
```

### 마이그레이션 (0.0.1 → 0.0.2)

`ContextualBarItem.icon`이 제거되고, `unselectedWidget` + (옵션) `selectedWidget`으로 변경되었습니다.

```dart
// before
ContextualBarItem(id: 'home', icon: Icon(Icons.home_outlined), label: '홈');

// after
ContextualBarItem(
  id: 'home',
  label: '홈',
  unselectedWidget: Icon(Icons.home_outlined),
  selectedWidget: Icon(Icons.home),
);
```

## 라이선스

`LICENSE`를 참고하세요.

