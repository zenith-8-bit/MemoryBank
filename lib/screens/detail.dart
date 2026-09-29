import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../theme.dart';
import 'add_memory.dart';

class DetailScreen extends StatelessWidget {
  final int id;
  const DetailScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<List<Memory>>(
        valueListenable: store,
        builder: (context, list, _) {
          final m = list.where((x) => x.id == id).firstOrNull;
          if (m == null) return const Scaffold();
          final rel = [...list.where((x) => x.id != id && x.category == m.category), ...list.where((x) => x.id != id && x.category != m.category)].take(3).toList();
          final srcIcon = switch (m.source) { 'voice' => Icons.mic, 'image' => Icons.image, 'scan' => Icons.document_scanner, 'chat' => Icons.chat_bubble, _ => Icons.edit_note };

          return Scaffold(
            body: SafeArea(
              child: ListView(padding: const EdgeInsets.all(20), children: [
                TopBar('Memory', actions: [
                  PopupMenuButton<String>(
                    color: N.white,
                    shape: const RoundedRectangleBorder(side: BorderSide(color: N.ink, width: 3)),
                    child: const NeoBox(shadow: 3, padding: EdgeInsets.all(6), child: Icon(Icons.more_horiz)),
                    onSelected: (v) async {
                      if (v == 'pin') updateMemory(m.copyWith(pinned: !m.pinned));
                      if (v == 'copy') {
                        await Clipboard.setData(ClipboardData(text: '${m.title}\n${m.body}'));
                        if (context.mounted) toast(context, 'Copied to clipboard');
                      }
                      if (v == 'delete' && await confirm(context, 'Delete memory?', '"${m.title}" will be removed.')) {
                        if (context.mounted) Navigator.pop(context);
                        deleteMemory(m.id);
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'pin', child: Text(m.pinned ? 'Unpin' : 'Pin to top', style: N.body)),
                      const PopupMenuItem(value: 'copy', child: Text('Copy text', style: N.body)),
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: N.body)),
                    ],
                  ),
                ]),
                const SizedBox(height: 18),
                Container(
                  height: 180,
                  decoration: BoxDecoration(color: catColor(m.category), border: Border.all(color: N.ink, width: 3), boxShadow: const [BoxShadow(color: N.ink, offset: Offset(6, 6))]),
                  child: Stack(children: [
                    Center(child: Icon(catIcon(m.category), size: 84, color: N.ink)),
                    Positioned(right: 10, top: 10, child: NeoBox(shadow: 2, padding: const EdgeInsets.all(6), child: Icon(srcIcon, size: 18))),
                  ]),
                ),
                const SizedBox(height: 22),
                Text(m.title, style: N.title),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.calendar_today, size: 14), const SizedBox(width: 6), Text('${dayLabel(m.date)}, ${clock(m.date)}', style: N.small)]),
                if (m.location.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [const Icon(Icons.place, size: 14), const SizedBox(width: 6), Text(m.location, style: N.small)])),
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Tag(m.category)),
                const SizedBox(height: 16),
                NeoBox(child: Text(m.body, style: N.body.copyWith(height: 1.4))),
                const SizedBox(height: 22),
                const Text('RELATED MEMORIES', style: N.h2),
                const SizedBox(height: 10),
                Row(children: [
                  for (final r in rel)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: NeoBox(
                          color: catColor(r.category),
                          shadow: 3,
                          padding: const EdgeInsets.all(8),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(r.id))),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Icon(catIcon(r.category)),
                            const SizedBox(height: 4),
                            Text(r.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: N.small.copyWith(color: N.ink, fontWeight: FontWeight.w900)),
                            Text(ago(r.date), style: N.small),
                          ]),
                        ),
                      ),
                    ),
                ]),
                const SizedBox(height: 24),
                NeoButton('Edit Memory', icon: Icons.edit, color: N.yellow, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddMemoryScreen(edit: m)))),
              ]),
            ),
          );
        },
      );
}
