import 'package:flutter/material.dart';

class N {
  static const bg = Color(0xFFFFF4E0);
  static const ink = Color(0xFF111111);
  static const yellow = Color(0xFFFFD93D);
  static const pink = Color(0xFFFF8FAB);
  static const mint = Color(0xFF6BF0B5);
  static const blue = Color(0xFF7CB9FF);
  static const orange = Color(0xFFFF9F45);
  static const white = Colors.white;

  static const title = TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: ink);
  static const h2 = TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: ink);
  static const body = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ink);
  static const small = TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF444444));
}

class NeoBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double shadow;
  const NeoBox({
    super.key,
    required this.child,
    this.color = N.white,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.onLongPress,
    this.shadow = 5,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: N.ink, width: 3),
            boxShadow: [BoxShadow(color: N.ink, offset: Offset(shadow, shadow))],
          ),
          child: child,
        ),
      );
}

class NeoButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final VoidCallback onTap;
  const NeoButton(this.label, {super.key, required this.onTap, this.icon, this.color = N.mint});

  @override
  Widget build(BuildContext context) => NeoBox(
        color: color,
        onTap: onTap,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (icon != null) ...[Icon(icon, color: N.ink), const SizedBox(width: 8)],
          Text(label.toUpperCase(), style: N.h2),
        ]),
      );
}

class NeoChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const NeoChip(this.label, {super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 6),
        child: NeoBox(
          onTap: onTap,
          shadow: selected ? 0 : 3,
          color: selected ? N.yellow : N.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(label, style: N.body.copyWith(fontWeight: FontWeight.w900)),
        ),
      );
}

class NeoField extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData? icon;
  final int lines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  const NeoField({super.key, this.controller, required this.hint, this.icon, this.lines = 1, this.onChanged, this.onSubmitted});

  @override
  Widget build(BuildContext context) => NeoBox(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          maxLines: lines,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          style: N.body,
          cursorColor: N.ink,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: N.small,
            icon: icon == null ? null : Icon(icon, color: N.ink),
          ),
        ),
      );
}

class Tag extends StatelessWidget {
  final String text;
  const Tag(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(color: catColor(text), border: Border.all(color: N.ink, width: 2)),
        child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: N.ink)),
      );
}

Color catColor(String c) => switch (c) {
      'Travel' => N.orange,
      'People' => N.pink,
      'Study' => N.mint,
      'Food' => N.yellow,
      'Health' => N.blue,
      'Reminder' => N.pink,
      'Places' => N.blue,
      _ => N.white,
    };

IconData catIcon(String c) => switch (c) {
      'Travel' => Icons.terrain,
      'People' => Icons.person,
      'Study' => Icons.menu_book,
      'Food' => Icons.ramen_dining,
      'Health' => Icons.fitness_center,
      'Reminder' => Icons.alarm,
      _ => Icons.shopping_bag,
    };

class TopBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  const TopBar(this.title, {super.key, this.actions = const []});
  @override
  Widget build(BuildContext context) => Row(children: [
        GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const NeoBox(shadow: 3, padding: EdgeInsets.all(6), child: Icon(Icons.arrow_back))),
        const SizedBox(width: 14),
        Expanded(child: Text(title.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: N.title.copyWith(fontSize: 22))),
        ...actions,
      ]);
}

Future<bool> confirm(BuildContext c, String title, String msg, {String yes = 'Delete'}) async {
  const bold = TextStyle(color: N.ink, fontWeight: FontWeight.w900);
  final r = await showDialog<bool>(
    context: c,
    builder: (ctx) => AlertDialog(
      backgroundColor: N.white,
      shape: const RoundedRectangleBorder(side: BorderSide(color: N.ink, width: 3)),
      title: Text(title, style: N.h2),
      content: Text(msg, style: N.body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: bold)),
        TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(backgroundColor: N.pink), child: Text(yes, style: bold)),
      ],
    ),
  );
  return r ?? false;
}

void toast(BuildContext c, String m) => ScaffoldMessenger.of(c)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(
    backgroundColor: N.yellow,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(side: BorderSide(color: N.ink, width: 3)),
    content: Text(m, style: N.body.copyWith(fontWeight: FontWeight.w900)),
  ));
