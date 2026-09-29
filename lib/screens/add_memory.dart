import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class AddMemoryScreen extends StatefulWidget {
  final Memory? edit;
  final String mode;
  const AddMemoryScreen({super.key, this.edit, this.mode = 'Text'});
  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  late final ctrl = TextEditingController(text: widget.edit?.body ?? '');
  late String mode = widget.edit == null ? widget.mode : 'Text';
  late String cat = widget.edit?.category ?? 'People';
  late String location = widget.edit?.location ?? '';
  late DateTime date = widget.edit?.date ?? DateTime.now();
  bool ai = true, rec = false, attached = false;
  int secs = 0;
  Timer? timer;

  String fmt(int s) => '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';

  void toggleRec() {
    if (rec) {
      timer?.cancel();
      setState(() {
        rec = false;
        // TODO: plug in speech_to_text here to fill the transcript.
        if (ctrl.text.isEmpty) ctrl.text = 'Voice note (${fmt(secs)})';
      });
    } else {
      secs = 0;
      setState(() => rec = true);
      timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => secs++));
    }
  }

  Future<void> pickDate() async {
    final d = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d == null || !mounted) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(date));
    setState(() => date = DateTime(d.year, d.month, d.day, t?.hour ?? date.hour, t?.minute ?? date.minute));
  }

  Future<void> pickLocation() async {
    final c = TextEditingController(text: location);
    final r = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: N.white,
        shape: const RoundedRectangleBorder(side: BorderSide(color: N.ink, width: 3)),
        title: const Text('Location', style: N.h2),
        content: NeoField(controller: c, hint: 'e.g. Imphal, Manipur', icon: Icons.place),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx, c.text.trim()), style: TextButton.styleFrom(backgroundColor: N.mint), child: const Text('Set', style: TextStyle(color: N.ink, fontWeight: FontWeight.w900)))],
      ),
    );
    if (r != null) setState(() => location = r);
  }

  void save() {
    final t = ctrl.text.trim();
    if (t.isEmpty) {
      toast(context, 'Write something to remember first');
      return;
    }
    final first = t.split('\n').first;
    final title = first.length > 28 ? '${first.substring(0, 28)}...' : first;
    final e = widget.edit;
    if (e != null) {
      updateMemory(e.copyWith(title: title, body: t, category: cat, location: location, date: date));
    } else {
      addMemory(Memory(id: newId(), title: title, body: t, category: cat, date: date, location: location, source: mode.toLowerCase()));
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    ctrl.dispose();
    super.dispose();
  }

  Widget ctxChip(IconData i, String t, VoidCallback f) => Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 8),
        child: NeoBox(onTap: f, shadow: 3, color: N.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 16), const SizedBox(width: 6), Text(t, style: N.small.copyWith(color: N.ink, fontWeight: FontWeight.w900))])),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            TopBar(widget.edit == null ? 'Add memory' : 'Edit memory'),
            const SizedBox(height: 20),
            if (widget.edit == null) Row(children: [for (final t in ['Text', 'Voice', 'Image']) NeoChip(t, selected: mode == t, onTap: () => setState(() => mode = t))]),
            const SizedBox(height: 6),
            if (mode == 'Voice') ...[
              NeoBox(
                color: rec ? N.pink : N.orange,
                onTap: toggleRec,
                child: Column(children: [
                  Icon(rec ? Icons.stop_circle : Icons.mic, size: 60, color: N.ink),
                  Text(rec ? 'RECORDING ${fmt(secs)}  ·  TAP TO STOP' : 'TAP TO RECORD', style: N.h2),
                ]),
              ),
              const SizedBox(height: 14),
            ],
            if (mode == 'Image') ...[
              NeoBox(
                color: attached ? N.mint : N.blue,
                // TODO: plug in image_picker to attach a real photo.
                onTap: () => setState(() => attached = !attached),
                child: Column(children: [
                  Icon(attached ? Icons.check_circle : Icons.add_a_photo, size: 60, color: N.ink),
                  Text(attached ? 'PHOTO ATTACHED · TAP TO REMOVE' : 'TAP TO ADD PHOTO', style: N.h2),
                ]),
              ),
              const SizedBox(height: 14),
            ],
            NeoField(controller: ctrl, hint: mode == 'Text' ? 'What do you want to remember?\nE.g. "Met with prof. Sharma", "Buy milk"' : mode == 'Voice' ? 'Transcript / notes' : 'Add a caption', lines: 6),
            const SizedBox(height: 22),
            const Text('ADD CONTEXT (OPTIONAL)', style: N.h2),
            const SizedBox(height: 10),
            Wrap(children: [
              ctxChip(Icons.place, location.isEmpty ? 'Location' : location, pickLocation),
              ctxChip(Icons.event, '${dayLabel(date)} ${clock(date)}', pickDate),
            ]),
            Wrap(children: [for (final c in addCategories) NeoChip(c, selected: cat == c, onTap: () => setState(() => cat = c))]),
            const SizedBox(height: 12),
            NeoBox(
              color: N.blue,
              child: Row(children: [
                const Expanded(child: Text('Save to memory bank\nLet AI understand and organize this for you.', style: N.body)),
                Switch(value: ai, activeColor: N.ink, activeTrackColor: N.mint, onChanged: (v) => setState(() => ai = v)),
              ]),
            ),
            const SizedBox(height: 26),
            NeoButton(widget.edit == null ? 'Save' : 'Update', icon: Icons.save, onTap: save),
          ]),
        ),
      );
}
