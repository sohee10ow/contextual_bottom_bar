import 'package:flutter/material.dart';
import 'package:contextual_bottom_bar/contextual_bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

/// sectionId(K) 예시: enum (타입 안전)
enum DemoSectionId { ticket }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'contextual_bottom_bar demo',
      theme: ThemeData.light(useMaterial3: true),
      home: const DemoHome(),
    );
  }
}

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  ContextualBarMode _mode = ContextualBarMode.global;

  int _globalIndex = 0;

  // 현재 섹션 (mode가 global이어도 “마지막 섹션”을 들고 있어도 됨)
  DemoSectionId _sectionId = DemoSectionId.ticket;

  // 섹션별 마지막 탭 기억 (요구사항: 섹션도 기억 UX 통일)
  final Map<DemoSectionId, int> _sectionIndexById = {
    DemoSectionId.ticket: 0,
  };

  // 현재 섹션에서 선택된 탭 (sectionId에 맞춰 map에서 가져옴)
  int get _sectionIndex => _sectionIndexById[_sectionId] ?? 0;

  // global 탭 구성 (예시)
  late final List<ContextualBarItem> _globalItems = [
    ContextualBarItem(
      id: 'home',
      unselectedWidget: const Icon(Icons.home_outlined),
      selectedWidget: const Icon(Icons.home),
      label: '홈',
    ),
    ContextualBarItem(
      id: 'benefit',
      unselectedWidget: const Icon(Icons.shopping_bag_outlined),
      selectedWidget: const Icon(Icons.shopping_bag),
      label: '혜택',
    ),
    ContextualBarItem(
      id: 'coupon',
      unselectedWidget: const Icon(Icons.show_chart),
      label: '쿠폰',
    ),
    ContextualBarItem(
      id: DemoSectionId.ticket,
      unselectedWidget: const Icon(Icons.confirmation_num_outlined),
      selectedWidget: const Icon(Icons.confirmation_num),
      label: '티켓',
    ),
    ContextualBarItem(
      id: 'myCoupon',
      unselectedWidget: const Icon(Icons.card_giftcard_outlined),
      selectedWidget: const Icon(Icons.card_giftcard),
      label: '내쿠폰함',
    ),
  ];

  List<ContextualBarItem> _sectionItems(DemoSectionId id) {
    switch (id) {
      case DemoSectionId.ticket:
        return const [
          ContextualBarItem(
            id: 'ticket',
            unselectedWidget: Icon(Icons.show_chart),
            label: '티켓',
          ),
          ContextualBarItem(
            id: 'watch',
            unselectedWidget: Icon(Icons.star_border),
            selectedWidget: Icon(Icons.star),
            label: '관심',
          ),
          ContextualBarItem(
            id: 'discover',
            unselectedWidget: Icon(Icons.explore_outlined),
            selectedWidget: Icon(Icons.explore),
            label: '발견',
          ),
          ContextualBarItem(
            id: 'feed',
            unselectedWidget: Icon(Icons.article_outlined),
            selectedWidget: Icon(Icons.article),
            label: '피드',
          ),
        ];
    }
  }

  String _screenTitle() {
    if (_mode == ContextualBarMode.global) {
      return 'GLOBAL: ${_globalItems[_globalIndex].label}';
    }
    final items = _sectionItems(_sectionId);
    final idx = _sectionIndex.clamp(0, items.length - 1);
    return 'SECTION(${_sectionId.name}): ${items[idx].label}';
  }

  void _handleTap(ContextualBarMode mode, int index, Object id) {
    setState(() {
      debugPrint('[demo] onTap mode=$mode index=$index id=$id');
      if (mode == ContextualBarMode.global) {
        _globalIndex = index;

        // global에서 “쇼핑/증권” 탭을 누르면 section 모드로 진입
        if (id is DemoSectionId) {
          _sectionId = id; // stocks or shopping
          _mode = ContextualBarMode.section;
          // sectionIndex는 섹션별 마지막 기억값을 그대로 사용
          _sectionIndexById[_sectionId] = _sectionIndexById[_sectionId] ?? 0;
        } else {
          // 홈 같은 전역 화면이면 global 유지
          _mode = ContextualBarMode.global;
        }
      } else {
        // section 탭 클릭: 섹션별 마지막 탭 기억
        _sectionIndexById[_sectionId] = index;
      }
    });
  }

  void _handleBack() {
    setState(() {
      debugPrint('[demo] back to global');
      _mode = ContextualBarMode.global; // globalIndex는 유지(너가 선택한 UX)
    });
  }

  @override
  Widget build(BuildContext context) {
    final sectionItems = _mode == ContextualBarMode.section
        ? _sectionItems(_sectionId)
        : const <ContextualBarItem>[];

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle()),
      ),
      body: Center(
        child: Text(
          _screenTitle(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      bottomNavigationBar: ContextualBottomBar<DemoSectionId>(
        mode: _mode,
        sectionId: _sectionId,
        globalIndex: _globalIndex,
        sectionIndex: _sectionIndex,
        globalItems: _globalItems,
        sectionItems: sectionItems,
        onTap: _handleTap,
        sectionLeading: _mode == ContextualBarMode.section
            ? Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(999)),
                  color: Color.fromARGB(255, 189, 189, 189),
                ),
                child: IconButton(
                    onPressed: _handleBack, icon: const Icon(Icons.arrow_back)),
              )
            : null,
        // 옵션들(너가 정한 기본 철학대로 필요 시만 만져)
        reserveLeadingSpace: false,

        useSafeArea: false,
        labelVisibility: ContextualBarLabelVisibility.always,
        style: const ContextualBarStyle(
          backgroundColor: Colors.transparent,
          selectedColor: Colors.black,
          unselectedColor: Colors.green,
        ),
        transition: const ContextualBarTransition(
          preset: ContextualBarTransitionPreset.fade, // default
          slideDirection: ContextualBarSlideDirection.rtl, // default
          duration: Duration(milliseconds: 250),
        ),
        ignoreInputDuringTransition: true,

        surfaceBuilder: (context, mode, child) {
          final bottomInset = MediaQuery.paddingOf(context).bottom;

          if (mode == ContextualBarMode.global) {
            // GLOBAL: 배경은 하단까지 꽉(홈 인디케이터 아래까지),
            // 컨텐츠만 bottomInset 만큼 올려서 안전하게.
            return DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24,
                    offset: Offset(0, -6),
                    color: Color(0x22000000),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset, top: 12),
                child: SizedBox(height: 56, child: child),
              ),
            );
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      offset: Offset(0, 10),
                      color: Color(0x22000000),
                    ),
                  ],
                ),
                child: SizedBox(height: 56, child: child),
              ),
            ),
          );
        },
      ),
    );
  }
}
