import 'package:flutter/foundation.dart';

class Memory {
  final int id;
  final String title, body, category, location, source;
  final DateTime date;
  final bool pinned;
  const Memory({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.date,
    this.location = '',
    this.source = 'text',
    this.pinned = false,
  });
  Memory copyWith({String? title, String? body, String? category, String? location, DateTime? date, bool? pinned}) => Memory(
        id: id,
        title: title ?? this.title,
        body: body ?? this.body,
        category: category ?? this.category,
        location: location ?? this.location,
        date: date ?? this.date,
        source: source,
        pinned: pinned ?? this.pinned,
      );
}

int _nextId = 100;
int newId() => _nextId++;
DateTime _ago({int d = 0, int h = 0}) => DateTime.now().subtract(Duration(days: d, hours: h));

final store = ValueNotifier<List<Memory>>([
  Memory(id: 1, title: 'Trip to Manipur', body: 'Went to Imphal with friends. Visited Kangla Fort, tried Ema Datshi, and explored the local markets. Definitely want to go back sometime.', category: 'Travel', date: _ago(h: 2), location: 'Imphal, Manipur'),
  Memory(id: 2, title: "Arjun's Birthday", body: 'Remember to get him the book he wanted.', category: 'People', date: _ago(d: 1)),
  Memory(id: 3, title: 'DMS Revision', body: 'Study modular arithmetic, CRT and congruences.', category: 'Study', date: _ago(d: 2)),
  Memory(id: 4, title: 'Imphal Floods Research', body: 'Read about flood prediction models.', category: 'Study', date: _ago(d: 3)),
  Memory(id: 5, title: 'Friend from Imphal', body: 'Met Arjun at the VIT fest. He is a Mechanical Engg. student (VIT-AP).', category: 'People', date: _ago(d: 8)),
  Memory(id: 6, title: 'Food recommendations', body: 'Ema Datshi is a must try in Imphal.', category: 'Food', date: _ago(d: 9), location: 'Imphal'),
  Memory(id: 7, title: 'Gym', body: 'Leg day. Felt good.', category: 'Health', date: _ago(h: 5)),
  Memory(id: 8, title: 'Bought laptop charger', body: 'From Amazon. Order #...', category: 'Shopping', date: _ago(d: 40)),
]);

void addMemory(Memory m) => store.value = [m, ...store.value];
void updateMemory(Memory m) => store.value = [for (final x in store.value) x.id == m.id ? m : x];
void deleteMemory(int id) => store.value = store.value.where((x) => x.id != id).toList();
List<Memory> sorted() => [...store.value]..sort((a, b) => b.date.compareTo(a.date));

const categories = ['All', 'People', 'Places', 'Study', 'Trips', 'Food', 'Health'];
const addCategories = ['People', 'Travel', 'Study', 'Food', 'Health', 'Shopping', 'Reminder'];

const _mon = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
bool sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

String dayLabel(DateTime d) {
  final n = DateTime.now();
  if (sameDay(d, n)) return 'Today';
  if (sameDay(d, n.subtract(const Duration(days: 1)))) return 'Yesterday';
  return '${d.day} ${_mon[d.month - 1]} ${d.year}';
}

String clock(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h:${d.minute.toString().padLeft(2, '0')} ${d.hour >= 12 ? 'PM' : 'AM'}';
}

String ago(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.isNegative) return 'Due ${dayLabel(d)}';
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  if (diff.inDays < 30) return '${diff.inDays ~/ 7} weeks ago';
  return '${diff.inDays ~/ 30} months ago';
}

// ---- app-wide state ----
final tabIndex = ValueNotifier<int>(0);
final userName = ValueNotifier<String>('Chingsang');
final userEmail = ValueNotifier<String>('chingsang@vitap.ac.in');
final autoCategorize = ValueNotifier<bool>(true);
final forgetAfter = ValueNotifier<String>('Never');
final aiModel = ValueNotifier<String>('Balanced');
final aiStyle = ValueNotifier<String>('Short');
final useContext = ValueNotifier<bool>(true);
final appLock = ValueNotifier<bool>(false);
final encryption = ValueNotifier<bool>(true);
final autoBackup = ValueNotifier<bool>(true);
final lastBackup = ValueNotifier<DateTime?>(null);
