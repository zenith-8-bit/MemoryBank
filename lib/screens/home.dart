import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'add_memory.dart';
import 'scan.dart';
import 'search.dart';
import 'detail.dart';

class MemoryTile extends StatelessWidget {
  final Memory m;
  const MemoryTile(this.m, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: NeoBox(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(m.id))),
          onLongPress: () async {
            if (await confirm(context, 'Delete memory?', '"${m.title}" will be removed.')) deleteMemory(m.id);
          },
          child: Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: catColor(m.category), border: Border.all(color: N.ink, width: 3)),
              child: Icon(catIcon(m.category), color: N.ink),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(m.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: N.h2)),
                  if (m.pinned) const Icon(Icons.push_pin, size: 16),
                ]),
                Text(m.body, maxLines: 1, overflow: TextOverflow.ellipsis, style: N.small),
                const SizedBox(height: 6),
                Row(children: [Tag(m.category), const Spacer(), Text(ago(m.date), style: N.small)]),
              ]),
            ),
          ]),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void go(BuildContext c, Widget w) => Navigator.push(c, MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greet = h < 12 ? 'Good morning,' : h < 17 ? 'Good afternoon,' : 'Good evening,';

    Widget action(String label, IconData icon, Color color, Widget target) => Expanded(
          child: NeoBox(
            color: color,
            onTap: () => go(context, target),
            child: Column(children: [Icon(icon, size: 30, color: N.ink), const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, style: N.body.copyWith(fontWeight: FontWeight.w900))]),
          ),
        );

    Widget stat(String v, String l, Color c) => Expanded(
          child: NeoBox(color: c, shadow: 3, padding: const EdgeInsets.symmetric(vertical: 10), child: Column(children: [Text(v, style: N.title), Text(l, style: N.small.copyWith(color: N.ink))])),
        );

    return ValueListenableBuilder<List<Memory>>(
      valueListenable: store,
      builder: (_, __, ___) {
        final all = sorted();
        final week = all.where((m) => DateTime.now().difference(m.date).inDays < 7).length;
        final rem = all.where((m) => m.category == 'Reminder').length;
        final recent = [...all.where((m) => m.pinned), ...all.where((m) => !m.pinned)].take(4).toList();
        return ListView(padding: const EdgeInsets.all(20), children: [
          Row(children: [
            const Expanded(child: Text('MEMORYBANK', style: N.title)),
            GestureDetector(
              onTap: () => tabIndex.value = 3,
              child: const NeoBox(color: N.pink, shadow: 3, padding: EdgeInsets.all(8), child: Icon(Icons.person, color: N.ink)),
            ),
          ]),
          const SizedBox(height: 18),
          Text(greet, style: N.body),
          ValueListenableBuilder<String>(
            valueListenable: userName,
            builder: (_, n, __) => Text('$n ☀', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: N.ink)),
          ),
          const Text("Here's what you've got.", style: N.small),
          const SizedBox(height: 16),
          NeoBox(
            onTap: () => go(context, const SearchScreen()),
            child: Row(children: [const Icon(Icons.search), const SizedBox(width: 10), Text('Search your memories...', style: N.small)]),
          ),
          const SizedBox(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            action('Add Memory', Icons.edit_note, N.blue, const AddMemoryScreen()),
            const SizedBox(width: 12),
            action('Scan Document', Icons.document_scanner, N.mint, const ScanScreen()),
            const SizedBox(width: 12),
            action('Voice Note', Icons.mic, N.orange, const AddMemoryScreen(mode: 'Voice')),
          ]),
          const SizedBox(height: 20),
          Row(children: [stat('${all.length}', 'MEMORIES', N.yellow), const SizedBox(width: 12), stat('$week', 'THIS WEEK', N.mint), const SizedBox(width: 12), stat('$rem', 'REMINDERS', N.pink)]),
          const SizedBox(height: 26),
          Row(children: [
            const Expanded(child: Text('RECENT MEMORIES', style: N.h2)),
            GestureDetector(onTap: () => tabIndex.value = 1, child: const Text('VIEW ALL →', style: TextStyle(fontWeight: FontWeight.w900, decoration: TextDecoration.underline))),
          ]),
          const SizedBox(height: 12),
          if (recent.isEmpty) const NeoBox(color: N.yellow, child: Text('No memories yet. Tap "Add Memory" to start.', style: N.body)),
          for (final m in recent) MemoryTile(m),
        ]);
      },
    );
  }
}
