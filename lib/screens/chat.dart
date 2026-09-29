import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ctrl = TextEditingController();
  final sc = ScrollController();
  final msgs = <(bool, String)>[(false, 'Hi! Ask me about your memories, or say "remind me to ..."')];
  bool typing = false, showMem = false;
  static const stop = {'what', 'which', 'where', 'when', 'about', 'name', 'tell', 'that', 'this', 'have', 'with', 'from', 'your', 'remind', 'did', 'was'};

  DateTime due(String s) {
    final n = DateTime.now();
    if (s.contains('today')) return n;
    if (s.contains('next week')) return n.add(const Duration(days: 7));
    final r = RegExp(r'in (\d+) days?').firstMatch(s);
    if (r != null) return n.add(Duration(days: int.parse(r.group(1)!)));
    return n.add(const Duration(days: 1));
  }

  String reply(String q) {
    final s = q.toLowerCase();
    if (s.contains('remind')) {
      final task = q.replaceFirst(RegExp(r'^\s*remind me( to)?\s*', caseSensitive: false), '');
      final d = due(s);
      addMemory(Memory(id: newId(), title: 'Reminder: $task', body: task, category: 'Reminder', date: d, source: 'chat'));
      return "Got it! I'll remind you on ${dayLabel(d)}: $task";
    }
    final words = s.split(RegExp(r'\W+')).where((w) => w.length > 3 && !stop.contains(w)).toList();
    Memory? best;
    var top = 0;
    for (final m in store.value) {
      final t = '${m.title} ${m.body} ${m.location}'.toLowerCase();
      final sc = words.where(t.contains).length;
      if (sc > top) { top = sc; best = m; }
    }
    return best == null ? "I couldn't find that in your memories yet." : '${best.title}: ${best.body}';
  }

  void send([String? text]) {
    final t = (text ?? ctrl.text).trim();
    if (t.isEmpty) return;
    setState(() { msgs.add((true, t)); ctrl.clear(); typing = true; });
    _down();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() { msgs.add((false, reply(t))); typing = false; });
      _down();
    });
  }

  void _down() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (sc.hasClients) sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      });

  @override
  void dispose() {
    ctrl.dispose();
    sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final m in store.value) { counts[m.category] = (counts[m.category] ?? 0) + 1; }
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(children: [
          const Expanded(child: Text('MEMORYBANK AI ✦', style: N.h2)),
          GestureDetector(
            onTap: () => setState(() => showMem = !showMem),
            child: NeoBox(color: showMem ? N.yellow : N.mint, shadow: 3, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text('Memory view', style: N.small.copyWith(color: N.ink, fontWeight: FontWeight.w900))),
          ),
        ]),
      ),
      if (showMem)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: NeoBox(
            color: N.white,
            shadow: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('AI can see ${store.value.length} memories', style: N.body.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 6, children: [for (final e in counts.entries) Tag('${e.key} ${e.value}')]),
            ]),
          ),
        ),
      Expanded(
        child: ListView(controller: sc, padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          for (final m in msgs)
            Align(
              alignment: m.$1 ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: NeoBox(color: m.$1 ? N.blue : N.white, shadow: 4, child: Text(m.$2, style: N.body)),
              ),
            ),
          if (typing) const Align(alignment: Alignment.centerLeft, child: NeoBox(color: N.yellow, shadow: 3, padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6), child: Text('...', style: N.h2))),
        ]),
      ),
      SizedBox(
        height: 46,
        child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20), children: [
          for (final s in ['What did I study?', 'Who is Arjun?', 'Remind me to call mom tomorrow']) NeoChip(s, selected: false, onTap: () => send(s)),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Row(children: [
          Expanded(child: NeoField(controller: ctrl, hint: 'Ask anything...', onSubmitted: send)),
          const SizedBox(width: 12),
          NeoBox(color: N.mint, onTap: send, padding: const EdgeInsets.all(14), child: const Icon(Icons.send, color: N.ink)),
        ]),
      ),
    ]);
  }
}
