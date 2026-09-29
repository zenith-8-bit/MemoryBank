import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  int stage = 0; // 0 viewfinder, 1 scanning, 2 result
  final title = TextEditingController();
  final text = TextEditingController();
  String cat = 'Study';

  Future<void> capture() async {
    setState(() => stage = 1);
    // TODO: plug in camera + google_mlkit_text_recognition for real OCR.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => stage = 2);
  }

  void save() {
    if (text.text.trim().isEmpty && title.text.trim().isEmpty) {
      toast(context, 'Add a title or some text');
      return;
    }
    final t = title.text.trim().isEmpty ? 'Scanned document' : title.text.trim();
    addMemory(Memory(id: newId(), title: t, body: text.text.trim(), category: cat, date: DateTime.now(), source: 'scan'));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    title.dispose();
    text.dispose();
    super.dispose();
  }

  Widget corner(Alignment a) => Align(
        alignment: a,
        child: Container(width: 34, height: 34, decoration: BoxDecoration(border: Border.all(color: N.yellow, width: 5))),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(20), children: [
            const TopBar('Scan document'),
            const SizedBox(height: 20),
            if (stage < 2) ...[
              NeoBox(
                color: N.ink,
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: 320,
                  child: Stack(children: [
                    corner(Alignment.topLeft), corner(Alignment.topRight), corner(Alignment.bottomLeft), corner(Alignment.bottomRight),
                    Center(
                      child: stage == 1
                          ? const CircularProgressIndicator(color: N.yellow, strokeWidth: 6)
                          : const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.description, size: 80, color: N.yellow), SizedBox(height: 10), Text('ALIGN DOCUMENT IN FRAME', style: TextStyle(color: N.white, fontWeight: FontWeight.w900))]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              NeoButton(stage == 1 ? 'Scanning...' : 'Capture', icon: Icons.camera_alt, color: N.mint, onTap: stage == 1 ? () {} : capture),
            ] else ...[
              const NeoBox(color: N.mint, child: Text('Scan complete. Review and edit the extracted text.', style: N.body)),
              const SizedBox(height: 16),
              NeoField(controller: title, hint: 'Document title'),
              const SizedBox(height: 14),
              NeoField(controller: text, hint: 'Extracted text appears here (connect OCR) or type it', lines: 8),
              const SizedBox(height: 14),
              Wrap(children: [for (final c in addCategories) NeoChip(c, selected: cat == c, onTap: () => setState(() => cat = c))]),
              const SizedBox(height: 16),
              NeoButton('Save to memory bank', icon: Icons.save, onTap: save),
              const SizedBox(height: 14),
              NeoButton('Retake', icon: Icons.refresh, color: N.yellow, onTap: () => setState(() => stage = 0)),
            ],
          ]),
        ),
      );
}
