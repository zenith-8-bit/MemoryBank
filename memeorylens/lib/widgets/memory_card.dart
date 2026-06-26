import 'package:flutter/material.dart';
import '../models/memory_item.dart';

Color _cardBg(MemoryType type) {
  switch (type) {
    case MemoryType.event:
      return const Color(0xFF1C1C1E);
    case MemoryType.payment:
      return Colors.white;
    case MemoryType.flight:
      return Colors.white;
    case MemoryType.reminder:
      return const Color(0xFFFFFDE7);
    case MemoryType.task:
      return Colors.white;
    case MemoryType.wifi:
      return Colors.white;
    case MemoryType.subscription:
      return Colors.white;
  }
}

Color _cardText(MemoryType type) {
  return type == MemoryType.event ? Colors.white : const Color(0xFF1C1C1E);
}

IconData _typeIcon(MemoryType type) {
  switch (type) {
    case MemoryType.event:
      return Icons.calendar_today_rounded;
    case MemoryType.payment:
      return Icons.payment_rounded;
    case MemoryType.flight:
      return Icons.flight_rounded;
    case MemoryType.reminder:
      return Icons.sticky_note_2_outlined;
    case MemoryType.task:
      return Icons.check_circle_outline_rounded;
    case MemoryType.wifi:
      return Icons.wifi_rounded;
    case MemoryType.subscription:
      return Icons.fitness_center_rounded;
  }
}

Widget _cardContent(MemoryItem item) {
  final fg = _cardText(item.type);
  final isDark = item.type == MemoryType.event;
  final isNote = item.type == MemoryType.reminder;

  if (item.type == MemoryType.event) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interview with ABC Corp',
          style: TextStyle(
            color: const Color(0xFF5B9BD5),
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        _iconRow(Icons.calendar_today_outlined, 'Tue, 18 Jul 2025', Colors.white70),
        const SizedBox(height: 3),
        _iconRow(Icons.access_time_rounded, '3:00 PM – 4:00 PM', Colors.white70),
        const SizedBox(height: 3),
        _iconRow(Icons.location_on_outlined, 'Conference Room 2B', Colors.white70),
      ],
    );
  }

  if (isNote) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1C1C1E),
            height: 1.4,
          ),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  if (item.type == MemoryType.wifi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Wi-Fi', style: TextStyle(fontSize: 11, color: fg.withOpacity(0.6))),
        Text('Home_Network_5G', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        const SizedBox(height: 4),
        Text('Password', style: TextStyle(fontSize: 11, color: fg.withOpacity(0.6))),
        Text('Abc123@#', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
      ],
    );
  }

  if (item.type == MemoryType.flight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('AI 302', style: TextStyle(fontSize: 11, color: fg.withOpacity(0.6))),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF5B9BD5)),
            children: [
              TextSpan(text: 'DEL '),
              WidgetSpan(child: Icon(Icons.arrow_forward, size: 12, color: const Color(0xFF5B9BD5))),
              TextSpan(text: ' BOM'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text('19 Jul • 7:45 AM', style: TextStyle(fontSize: 10, color: fg.withOpacity(0.55))),
        Text('PNR: 6E123B', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: const Color(0xFF5B9BD5))),
      ],
    );
  }

  if (item.type == MemoryType.payment) {
    final lines = item.title.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lines[0], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C1C1E))),
        if (lines.length > 1)
          Text(lines[1], style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
        const SizedBox(height: 4),
        if (item.detail1 != null)
          Text(item.detail1!, style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
        if (item.detail2 != null)
          Text(item.detail2!, style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
      ],
    );
  }

  if (item.type == MemoryType.subscription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gym Membership', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
        const SizedBox(height: 2),
        Text('₹3,999 / month', style: TextStyle(fontSize: 12, color: fg)),
        const SizedBox(height: 2),
        Text('Renewal: 15 Aug', style: TextStyle(fontSize: 10, color: fg.withOpacity(0.6))),
      ],
    );
  }

  // task / generic
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: fg, height: 1.4),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}

Widget _iconRow(IconData icon, String text, Color color) {
  return Row(
    children: [
      Icon(icon, size: 11, color: color),
      const SizedBox(width: 4),
      Expanded(child: Text(text, style: TextStyle(fontSize: 10, color: color))),
    ],
  );
}

class MemoryCard extends StatelessWidget {
  final MemoryItem item;
  final VoidCallback? onTap;

  const MemoryCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = _cardBg(item.type);
    final isDark = item.type == MemoryType.event;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: isDark ? null : Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _cardContent(item)),
                ],
              ),
            ),
            if (item.isStarred)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.star_outline_rounded, size: 16, color: isDark ? Colors.white54 : const Color(0xFF8E8E93)),
              ),
            // resize handle top-right for non-dark
            if (!isDark)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.open_in_full_rounded, size: 13, color: const Color(0xFFCCCCCC)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Bottom label strip shown on Capture screen cards
class MemoryCardWithLabel extends StatelessWidget {
  final MemoryItem item;

  const MemoryCardWithLabel({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: MemoryCard(item: item)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.subtitle,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1C1C1E)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.timeLabel,
                style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93)),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}