enum MemoryType { event, payment, flight, reminder, task, wifi, subscription }

class MemoryItem {
  final String id;
  final MemoryType type;
  final String title;
  final String subtitle;
  final String timeLabel;
  final String? detail1;
  final String? detail2;
  final String? detail3;
  final bool isStarred;

  const MemoryItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    this.detail1,
    this.detail2,
    this.detail3,
    this.isStarred = false,
  });
}

final List<MemoryItem> kMemoryItems = [
  MemoryItem(
    id: '1',
    type: MemoryType.event,
    title: 'Interview with ABC Corp',
    subtitle: 'Interview with ABC Corp',
    timeLabel: 'Today, 3:00 PM',
    detail1: 'Tue, 18 Jul 2025',
    detail2: '3:00 PM – 4:00 PM',
    detail3: 'Conference Room 2B',
    isStarred: true,
  ),
  MemoryItem(
    id: '2',
    type: MemoryType.payment,
    title: '₹2,500\nPaid to Zylker',
    subtitle: 'Payment to Zylker',
    timeLabel: 'Yesterday',
    detail1: 'UPI • 17 Jul 2025',
    detail2: 'Ref ID: 3456',
  ),
  MemoryItem(
    id: '3',
    type: MemoryType.flight,
    title: 'AI 302\nDEL → BOM',
    subtitle: 'Flight to Mumbai',
    timeLabel: '19 Jul, 7:45 AM',
    detail1: '19 Jul • 7:45 AM',
    detail2: 'PNR: 6E123B',
  ),
  MemoryItem(
    id: '4',
    type: MemoryType.reminder,
    title: 'Don\'t forget!\nBring your portfolio to interview',
    subtitle: 'Bring portfolio',
    timeLabel: 'Reminder',
  ),
  MemoryItem(
    id: '5',
    type: MemoryType.wifi,
    title: 'Wi-Fi\nHome_Network_5G\nPassword\nAbc123@#',
    subtitle: 'Wi-Fi Password',
    timeLabel: 'Saved',
  ),
  MemoryItem(
    id: '6',
    type: MemoryType.task,
    title: 'Submit report\nby 20 July',
    subtitle: 'Submit report',
    timeLabel: 'Due 20 Jul',
  ),
  MemoryItem(
    id: '7',
    type: MemoryType.subscription,
    title: 'Gym Membership\n₹3,999 / month\nRenewal: 15 Aug',
    subtitle: 'Gym membership',
    timeLabel: 'Renewal 15 Aug',
  ),
  MemoryItem(
    id: '8',
    type: MemoryType.task,
    title: 'Call John\nabout proposal tomorrow',
    subtitle: 'Call John',
    timeLabel: 'Task',
  ),
  MemoryItem(
    id: '9',
    type: MemoryType.payment,
    title: 'Electricity Bill\n₹1,240\nDue: 12 Jul 2025',
    subtitle: 'Electricity Bill',
    timeLabel: '₹1,240 • Due 12 Jul',
  ),
];