import 'package:contextual_bottom_bar/contextual_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('calls onTap with mode/index/id', (tester) async {
    final calls = <(ContextualBarMode, int, Object)>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ContextualBottomBar<String>(
            mode: ContextualBarMode.global,
            sectionId: 'ticket',
            globalIndex: 0,
            sectionIndex: 0,
            globalItems: const [
              ContextualBarItem(
                id: 'home',
                label: 'Home',
                unselectedWidget: Icon(Icons.home_outlined),
                selectedWidget: Icon(Icons.home),
              ),
              ContextualBarItem(
                id: 'search',
                label: 'Search',
                unselectedWidget: Icon(Icons.search_outlined),
                selectedWidget: Icon(Icons.search),
              ),
            ],
            sectionItems: const [],
            onTap: (mode, index, id) => calls.add((mode, index, id)),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Search'));
    await tester.pump();

    expect(calls, [(ContextualBarMode.global, 1, 'search')]);
  });

  testWidgets('renders selected/unselected widgets', (tester) async {
    const selectedKey = ValueKey<String>('selected');
    const unselectedKey = ValueKey<String>('unselected');

    Widget build(int selectedIndex) {
      return MaterialApp(
        home: Scaffold(
          bottomNavigationBar: ContextualBottomBar<String>(
            mode: ContextualBarMode.global,
            sectionId: 'ticket',
            globalIndex: selectedIndex,
            sectionIndex: 0,
            globalItems: const [
              ContextualBarItem(
                id: 'a',
                label: 'A',
                selectedWidget: SizedBox(key: selectedKey),
                unselectedWidget: SizedBox(key: unselectedKey),
              ),
              ContextualBarItem(
                id: 'b',
                label: 'B',
                unselectedWidget: SizedBox(),
              ),
            ],
            sectionItems: const [],
            onTap: _noopOnTap,
          ),
        ),
      );
    }

    await tester.pumpWidget(build(0));
    expect(find.byKey(selectedKey), findsOneWidget);
    expect(find.byKey(unselectedKey), findsNothing);

    await tester.pumpWidget(build(1));
    await tester.pump();
    expect(find.byKey(selectedKey), findsNothing);
    expect(find.byKey(unselectedKey), findsOneWidget);
  });
}

void _noopOnTap(ContextualBarMode mode, int index, Object id) {}
