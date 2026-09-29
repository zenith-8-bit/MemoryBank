import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'home.dart';
import 'timeline.dart';
import 'chat.dart';
import 'settings.dart';

class _Keep extends StatefulWidget {
  final Widget child;
  const _Keep(this.child);
  @override
  State<_Keep> createState() => _KeepState();
}

class _KeepState extends State<_Keep> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final pc = PageController();
  static const items = [(Icons.home, 'Home'), (Icons.view_timeline, 'Timeline'), (Icons.chat_bubble, 'Chat'), (Icons.menu, 'More')];

  @override
  void initState() {
    super.initState();
    tabIndex.value = 0;
    tabIndex.addListener(_sync);
  }

  void _sync() {
    if (pc.hasClients && pc.page?.round() != tabIndex.value) {
      pc.animateToPage(tabIndex.value, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    tabIndex.removeListener(_sync);
    pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: PageView(
            controller: pc,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => tabIndex.value = i,
            children: const [_Keep(HomeScreen()), _Keep(TimelineScreen()), _Keep(ChatScreen()), _Keep(SettingsScreen())],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(color: N.white, border: Border(top: BorderSide(color: N.ink, width: 3))),
          child: SafeArea(
            child: ValueListenableBuilder<int>(
              valueListenable: tabIndex,
              builder: (_, cur, __) => Row(children: [
                for (var k = 0; k < items.length; k++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => tabIndex.value = k,
                      child: Container(
                        color: cur == k ? N.yellow : N.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Icon(items[k].$1, color: N.ink),
                          Text(items[k].$2, style: N.small.copyWith(color: N.ink, fontWeight: FontWeight.w900)),
                        ]),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      );
}
