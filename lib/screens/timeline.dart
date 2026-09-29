import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'home.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});
  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  String f = 'All';
  DateTime? day;

  bool keep(Memory m) {
    if (day != null) return sameDay(m.date, day!);
    final d = DateTime.now().difference(m.date).inDays;
    return switch (f) { 'This Week' => d < 7, 'This Month' => d < 30, 'Older' => d >= 30, _ => true };
  }

  Future<void> pickDay() async {
    final d = await showDatePicker(context: context, initialDate: day ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => day = d);
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<List<Memory>>(
        valueListenable: store,
        builder: (_, __, ___) {
          final items = sorted().where(keep).toList();
          final rows = <Widget>[];
          String? last;
          for (final m in items) {
            final lbl = dayLabel(m.date);
            if (lbl != last) {
              last = lbl;
              rows.add(Padding(padding: const EdgeInsets.only(bottom: 10, top: 6), child: Align(alignment: Alignment.centerLeft, child: NeoBox(color: N.yellow, shadow: 3, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), child: Text(lbl.toUpperCase(), style: N.small.copyWith(color: N.ink, fontWeight: FontWeight.w900))))));
            }
            rows.add(IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Column(children: [
                  Container(width: 16, height: 16, decoration: BoxDecoration(color: catColor(m.category), border: Border.all(color: N.ink, width: 3))),
                  Expanded(child: Container(width: 3, color: N.ink)),
                ]),
                const SizedBox(width: 12),
                Expanded(child: MemoryTile(m)),
              ]),
            ));
          }
          return ListView(padding: const EdgeInsets.all(20), children: [
            Row(children: [
              const Expanded(child: Text('TIMELINE', style: N.title)),
              GestureDetector(onTap: pickDay, child: const NeoBox(color: N.blue, shadow: 3, padding: EdgeInsets.all(8), child: Icon(Icons.calendar_month))),
            ]),
            const SizedBox(height: 14),
            Wrap(children: [
              for (final t in ['All', 'This Week', 'This Month', 'Older']) NeoChip(t, selected: day == null && f == t, onTap: () => setState(() { f = t; day = null; })),
              if (day != null) NeoChip('${dayLabel(day!)}  ✕', selected: true, onTap: () => setState(() => day = null)),
            ]),
            const SizedBox(height: 8),
            if (items.isEmpty) const NeoBox(color: N.pink, child: Text('No memories in this range.', style: N.body)),
            ...rows,
          ]);
        },
      );
}
