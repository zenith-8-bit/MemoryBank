import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'home.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ctrl = TextEditingController();
  String q = '';
  String cat = 'All';

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  bool ok(Memory m) {
    final hit = '${m.title} ${m.body} ${m.location}'.toLowerCase().contains(q.toLowerCase());
    final c = switch (cat) {
      'All' => true,
      'Trips' => m.category == 'Travel',
      'Places' => m.location.isNotEmpty,
      _ => m.category == cat,
    };
    return hit && c;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder<List<Memory>>(
            valueListenable: store,
            builder: (_, __, ___) {
              final res = sorted().where(ok).toList();
              return ListView(padding: const EdgeInsets.all(20), children: [
                const TopBar('Search'),
                const SizedBox(height: 16),
                NeoBox(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(children: [
                    const Icon(Icons.search),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: ctrl,
                        autofocus: true,
                        style: N.body,
                        cursorColor: N.ink,
                        onChanged: (v) => setState(() => q = v),
                        decoration: InputDecoration(border: InputBorder.none, hintText: 'Try "Imphal"', hintStyle: N.small),
                      ),
                    ),
                    if (q.isNotEmpty)
                      GestureDetector(onTap: () => setState(() { ctrl.clear(); q = ''; }), child: const Icon(Icons.close)),
                  ]),
                ),
                const SizedBox(height: 14),
                Wrap(children: [for (final c in categories) NeoChip(c, selected: cat == c, onTap: () => setState(() => cat = c))]),
                const SizedBox(height: 10),
                Text('RESULTS (${res.length})', style: N.h2),
                const SizedBox(height: 12),
                if (res.isEmpty) const NeoBox(color: N.pink, child: Text('Nothing found. Try another word or filter.', style: N.body)),
                for (final m in res) MemoryTile(m),
              ]);
            },
          ),
        ),
      );
}
