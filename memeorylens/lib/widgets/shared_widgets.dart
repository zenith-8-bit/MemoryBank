import '../models/models.dart';

class MockData {
  // ── ONBOARDING ─────────────────────────────
  static const List<FeatureItem> features = [
    FeatureItem(
      icon: 'camera',
      title: 'Auto capture',
      description: 'Screenshots, receipts and more',
    ),
    FeatureItem(
      icon: 'grid',
      title: 'Smart organize',
      description: 'Everything in one place',
    ),
    FeatureItem(
      icon: 'bell',
      title: 'Reminders',
      description: 'Never miss what matters',
    ),
    FeatureItem(
      icon: 'chat',
      title: 'Ask anything',
      description: 'Find answers instantly',
    ),
  ];

  static const List<PersonaOption> personas = [
    PersonaOption(id: 'student', label: 'Student'),
    PersonaOption(id: 'professional', label: 'Professional'),
    PersonaOption(id: 'business_owner', label: 'Business Owner'),
  ];

  static const List<PriorityOption> priorities = [
    PriorityOption(id: 'work', label: 'Work & Productivity'),
    PriorityOption(id: 'finance', label: 'Finance & Payments'),
    PriorityOption(id: 'study', label: 'Study & Learning'),
    PriorityOption(id: 'health', label: 'Health & Fitness'),
    PriorityOption(id: 'travel', label: 'Travel'),
    PriorityOption(id: 'other', label: 'Other'),
  ];

  // ── CAPTURES ────────────────────────────────
  static List<CaptureItem> captures = [
    CaptureItem(
      id: 'c1',
      title: 'Electricity Bill',
      amount: '₹1,240',
      capturedAt: DateTime(2025, 7, 12),
      type: CaptureType.bill,
    ),
    CaptureItem(
      id: 'c2',
      title: 'Amazon Order',
      amount: '₹899',
      capturedAt: DateTime(2025, 7, 8),
      type: CaptureType.shopping,
    ),
    CaptureItem(
      id: 'c3',
      title: 'Gym Membership',
      amount: '₹3,999',
      capturedAt: DateTime(2025, 7, 15),
      type: CaptureType.health,
    ),
    CaptureItem(
      id: 'c4',
      title: 'Meeting Notes',
      capturedAt: DateTime(2025, 7, 19, 10, 30),
      type: CaptureType.document,
    ),
  ];

  // ── MEMORIES ────────────────────────────────
  static List<MemoryItem> memories = [
    MemoryItem(
      id: 'm1',
      title: 'Interview with ABC Corp',
      subtitle: 'Tue, 18 Jul 2025  3:00 PM • Conf. Room 2B',
      type: MemoryType.event,
      capturedAt: DateTime(2025, 7, 18, 15, 0),
      isStarred: true,
    ),
    MemoryItem(
      id: 'm2',
      title: 'Payment to Zylker',
      subtitle: '17 Jul, 1:42 PM',
      type: MemoryType.payment,
      capturedAt: DateTime(2025, 7, 17, 13, 42),
      amount: '₹2,500',
    ),
    MemoryItem(
      id: 'm3',
      title: 'Flight to Mumbai',
      subtitle: '19 Jul, 7:45 AM  DEL → BOM',
      description: 'PNR: 6E1238',
      type: MemoryType.travel,
      capturedAt: DateTime(2025, 7, 19, 7, 45),
    ),
    MemoryItem(
      id: 'm4',
      title: "Don't forget!",
      subtitle: 'Bring your portfolio to interview',
      type: MemoryType.note,
      capturedAt: DateTime(2025, 7, 17),
      isHighlighted: true,
    ),
    MemoryItem(
      id: 'm5',
      title: 'Wi-Fi Password',
      subtitle: 'Home_Network_5G',
      description: 'Abc123@#',
      type: MemoryType.info,
      capturedAt: DateTime(2025, 7, 10),
    ),
    MemoryItem(
      id: 'm6',
      title: 'Gym Membership',
      subtitle: '₹3,999 / month',
      description: 'Renewal: 15 Aug',
      type: MemoryType.health,
      capturedAt: DateTime(2025, 7, 15),
      isStarred: true,
    ),
  ];

  // ── PAYMENTS ────────────────────────────────
  static List<PaymentItem> payments = [
    PaymentItem(
      id: 'p1',
      title: 'Payment to Zylker',
      amount: '₹2,500',
      date: DateTime(2025, 7, 17),
      accountMasked: 'Bank •••• 1234',
      category: PaymentCategory.all,
      iconLabel: 'Z',
    ),
    PaymentItem(
      id: 'p2',
      title: 'Gym Membership',
      amount: '₹3,999',
      date: DateTime(2025, 7, 15),
      accountMasked: 'Bank •••• 3456',
      category: PaymentCategory.subscriptions,
      iconLabel: 'G',
    ),
    PaymentItem(
      id: 'p3',
      title: 'Electricity Bill',
      amount: '₹1,240',
      date: DateTime(2025, 7, 12),
      accountMasked: 'UPI •••• 3456',
      category: PaymentCategory.bills,
      isPaid: true,
      iconLabel: 'E',
    ),
    PaymentItem(
      id: 'p4',
      title: 'Amazon Purchase',
      amount: '₹899',
      date: DateTime(2025, 7, 8),
      accountMasked: 'Card •••• 5678',
      category: PaymentCategory.shopping,
      iconLabel: 'A',
    ),
    PaymentItem(
      id: 'p5',
      title: 'Internet Bill',
      amount: '₹799',
      date: DateTime(2025, 6, 28),
      accountMasked: 'UPI •••• 1234',
      category: PaymentCategory.bills,
      isPaid: true,
      iconLabel: 'I',
    ),
  ];

  // Monthly bar chart data (last 7 days placeholder)
  static const List<double> spendingBars = [0.4, 0.6, 0.3, 0.8, 0.5, 1.0, 0.7];

  // ── ASK SUGGESTIONS ─────────────────────────
  static const List<AskSuggestion> askSuggestions = [
    AskSuggestion(
      id: 'a1',
      question: 'What is my interview schedule next week?',
      iconKey: 'calendar',
    ),
    AskSuggestion(
      id: 'a2',
      question: 'Show my payments in July',
      iconKey: 'payment',
    ),
    AskSuggestion(
      id: 'a3',
      question: 'Where is my flight ticket?',
      iconKey: 'travel',
    ),
  ];
}