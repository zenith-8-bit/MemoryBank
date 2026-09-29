import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';
import '../theme.dart';
import 'splash.dart';

// ---------- helpers ----------
class SubPage extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SubPage(this.title, this.children, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: ListView(padding: const EdgeInsets.all(20), children: [TopBar(title), const SizedBox(height: 18), ...children])),
      );
}

Widget switchRow(String t, String s, ValueNotifier<bool> v) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NeoBox(
        child: ValueListenableBuilder<bool>(
          valueListenable: v,
          builder: (_, on, __) => Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: N.h2), Text(s, style: N.small)])),
            Switch(value: on, activeColor: N.ink, activeTrackColor: N.mint, onChanged: (x) => v.value = x),
          ]),
        ),
      ),
    );

Widget chipRow(String title, List<String> opts, ValueNotifier<String> v) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: NeoBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: N.h2),
          const SizedBox(height: 10),
          ValueListenableBuilder<String>(
            valueListenable: v,
            builder: (_, cur, __) => Wrap(children: [for (final o in opts) NeoChip(o, selected: cur == o, onTap: () => v.value = o)]),
          ),
        ]),
      ),
    );

Widget actionRow(String label, IconData i, Color c, VoidCallback f) => Padding(padding: const EdgeInsets.only(bottom: 14), child: NeoButton(label, icon: i, color: c, onTap: f));

// ---------- main settings ----------
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget tile(BuildContext c, IconData i, String t, String s, Color col, Widget page) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: NeoBox(
          onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => page)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: col, border: Border.all(color: N.ink, width: 3)), child: Icon(i, color: N.ink)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: N.h2), if (s.isNotEmpty) Text(s, style: N.small)])),
            const Icon(Icons.chevron_right),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
        const Text('SETTINGS', style: N.title),
        const SizedBox(height: 16),
        NeoBox(
          color: N.yellow,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
          child: Row(children: [
            const Icon(Icons.account_circle, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: ValueListenableBuilder2(
                a: userName,
                b: userEmail,
                builder: (n, e) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: N.h2), Text(e, style: N.small)]),
              ),
            ),
            const Icon(Icons.chevron_right),
          ]),
        ),
        const SizedBox(height: 18),
        tile(context, Icons.psychology, 'Memory Preferences', 'What to remember, what to forget', N.pink, const MemoryPrefsPage()),
        tile(context, Icons.auto_awesome, 'AI Settings', 'Model, response style, context', N.blue, const AiPage()),
        tile(context, Icons.lock, 'Privacy & Security', 'Data control, encryption', N.mint, const PrivacyPage()),
        tile(context, Icons.sync, 'Backup & Sync', 'Keep your memories safe', N.orange, const BackupPage()),
        tile(context, Icons.help, 'Help & Support', '', N.white, const HelpPage()),
        tile(context, Icons.info, 'About MemoryBank', '', N.white, const AboutPage()),
        const SizedBox(height: 6),
        NeoButton('Log Out', icon: Icons.logout, color: N.pink, onTap: () async {
          if (await confirm(context, 'Log out?', 'You will return to the welcome screen.', yes: 'Log out') && context.mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (_) => false);
          }
        }),
      ]);
}

class ValueListenableBuilder2 extends StatelessWidget {
  final ValueNotifier<String> a, b;
  final Widget Function(String, String) builder;
  const ValueListenableBuilder2({super.key, required this.a, required this.b, required this.builder});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<String>(
        valueListenable: a,
        builder: (_, x, __) => ValueListenableBuilder<String>(valueListenable: b, builder: (_, y, __) => builder(x, y)),
      );
}

// ---------- pages ----------
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final n = TextEditingController(text: userName.value);
  late final e = TextEditingController(text: userEmail.value);
  @override
  void dispose() {
    n.dispose();
    e.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SubPage('Profile', [
        const Center(child: NeoBox(color: N.yellow, shadow: 6, child: Icon(Icons.account_circle, size: 90))),
        const SizedBox(height: 22),
        NeoField(controller: n, hint: 'Name', icon: Icons.person),
        const SizedBox(height: 14),
        NeoField(controller: e, hint: 'Email', icon: Icons.mail),
        const SizedBox(height: 24),
        NeoButton('Save', icon: Icons.save, onTap: () {
          if (n.text.trim().isNotEmpty) userName.value = n.text.trim();
          if (e.text.trim().isNotEmpty) userEmail.value = e.text.trim();
          Navigator.pop(context);
        }),
      ]);
}

class MemoryPrefsPage extends StatelessWidget {
  const MemoryPrefsPage({super.key});
  @override
  Widget build(BuildContext context) => SubPage('Memory preferences', [
        switchRow('Auto-categorize', 'Let AI pick a category for new memories', autoCategorize),
        chipRow('Auto-forget shopping notes after', ['Never', '30 days', '90 days'], forgetAfter),
      ]);
}

class AiPage extends StatelessWidget {
  const AiPage({super.key});
  @override
  Widget build(BuildContext context) => SubPage('AI settings', [
        chipRow('Model', ['Fast', 'Balanced', 'Deep'], aiModel),
        chipRow('Response style', ['Short', 'Detailed', 'Casual'], aiStyle),
        switchRow('Use my memories as context', 'Answers are grounded in what you saved', useContext),
      ]);
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});
  @override
  Widget build(BuildContext context) => SubPage('Privacy & security', [
        switchRow('App lock', 'Require unlock when opening the app', appLock),
        switchRow('Encrypt memories', 'Encrypt data stored on this device', encryption),
        actionRow('Export memories (JSON)', Icons.ios_share, N.yellow, () async {
          final data = store.value.map((m) => {'title': m.title, 'body': m.body, 'category': m.category, 'location': m.location, 'date': m.date.toIso8601String()}).toList();
          await Clipboard.setData(ClipboardData(text: const JsonEncoder.withIndent('  ').convert(data)));
          if (context.mounted) toast(context, 'Copied ${data.length} memories to clipboard');
        }),
        actionRow('Delete all memories', Icons.delete_forever, N.pink, () async {
          if (await confirm(context, 'Delete everything?', 'This removes all ${store.value.length} memories and cannot be undone.', yes: 'Delete all')) {
            store.value = [];
            if (context.mounted) toast(context, 'All memories deleted');
          }
        }),
      ]);
}

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});
  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  double? progress;
  Timer? t;

  void run() {
    setState(() => progress = 0);
    // TODO: replace with a real cloud backup (Firebase / Drive).
    t = Timer.periodic(const Duration(milliseconds: 120), (x) {
      setState(() => progress = (progress ?? 0) + 0.1);
      if ((progress ?? 0) >= 1) {
        x.cancel();
        lastBackup.value = DateTime.now();
        setState(() => progress = null);
      }
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SubPage('Backup & sync', [
        switchRow('Auto backup', 'Back up whenever you add a memory', autoBackup),
        NeoBox(
          color: N.white,
          child: ValueListenableBuilder<DateTime?>(
            valueListenable: lastBackup,
            builder: (_, d, __) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Last backup', style: N.h2),
              Text(d == null ? 'Never' : '${dayLabel(d)}, ${clock(d)}', style: N.small),
              if (progress != null) ...[
                const SizedBox(height: 12),
                Container(
                  height: 18,
                  decoration: BoxDecoration(border: Border.all(color: N.ink, width: 3)),
                  child: Align(alignment: Alignment.centerLeft, child: FractionallySizedBox(widthFactor: progress!.clamp(0, 1), child: Container(color: N.mint))),
                ),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 18),
        NeoButton(progress == null ? 'Back up now' : 'Backing up...', icon: Icons.cloud_upload, color: N.orange, onTap: progress == null ? run : () {}),
      ]);
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});
  static const faq = [
    ('How do I add a memory?', 'Tap "Add Memory" on Home. Choose Text, Voice or Image, add optional context, then Save.'),
    ('How do I delete a memory?', 'Long-press it in any list, or open it and use the ••• menu.'),
    ('How does the AI find things?', 'Ask in the Chat tab. It searches your saved memories for the best match.'),
    ('Can I set reminders?', 'Yes. In Chat, say "remind me to ... tomorrow" or "in 3 days".'),
  ];
  @override
  Widget build(BuildContext context) => SubPage('Help & support', [for (final f in faq) _Faq(f.$1, f.$2)]);
}

class _Faq extends StatefulWidget {
  final String q, a;
  const _Faq(this.q, this.a);
  @override
  State<_Faq> createState() => _FaqState();
}

class _FaqState extends State<_Faq> {
  bool open = false;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: NeoBox(
          color: open ? N.yellow : N.white,
          onTap: () => setState(() => open = !open),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text(widget.q, style: N.h2)), Icon(open ? Icons.remove : Icons.add)]),
            if (open) Padding(padding: const EdgeInsets.only(top: 8), child: Text(widget.a, style: N.body)),
          ]),
        ),
      );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => const SubPage('About', [
        Center(child: NeoBox(color: N.pink, shadow: 8, padding: EdgeInsets.all(24), child: Icon(Icons.psychology, size: 80))),
        SizedBox(height: 22),
        Center(child: Text('MEMORYBANK', style: N.title)),
        Center(child: Text('Version 1.0.0', style: N.small)),
        SizedBox(height: 18),
        NeoBox(color: N.yellow, child: Text('A personal second brain. Capture today, find tomorrow.', textAlign: TextAlign.center, style: N.h2)),
      ]);
}
