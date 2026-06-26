import 'package:flutter/material.dart';
import '../models/memory_item.dart';
import '../widgets/memory_card.dart';
import '../models/memory_item.dart';
import '../widgets/memory_card.dart';

class AllMemoriesScreen extends StatefulWidget {
  const AllMemoriesScreen({super.key});

  @override
  State<AllMemoriesScreen> createState() => _AllMemoriesScreenState();
}

class _AllMemoriesScreenState extends State<AllMemoriesScreen> {
  int _filterIndex = 0;
  final _filters = ['All', 'Tasks', 'Events', 'Payments', 'Docs'];

  List<MemoryItem> get _filtered {
    if (_filterIndex == 0) return kMemoryItems;
    final map = {
      1: [MemoryType.task, MemoryType.reminder],
      2: [MemoryType.event],
      3: [MemoryType.payment],
      4: <MemoryType>[],
    };
    final types = map[_filterIndex] ?? [];
    return kMemoryItems.where((m) => types.contains(m.type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final items = _filtered;

    return Column(
      children: [
        SizedBox(height: top),
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Memories',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.history_rounded, size: 20, color: Color(0xFF1C1C1E)),
              ),
            ],
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, size: 18, color: Color(0xFF8E8E93)),
                const SizedBox(width: 8),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search anything...',
                      hintStyle: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                const Icon(Icons.tune_rounded, size: 18, color: Color(0xFF8E8E93)),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Filter chips
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final selected = i == _filterIndex;
              return GestureDetector(
                onTap: () => setState(() => _filterIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF007AFF) : const Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _filters[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : const Color(0xFF1C1C1E),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.88,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => MemoryCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}