import 'package:flutter/material.dart';

class _ChatMessage {
  final String text;
  final bool isUser;
  final Widget? richContent;

  const _ChatMessage({required this.text, required this.isUser, this.richContent});
}

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  final _controller = TextEditingController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(text: 'What is my interview schedule next week?', isUser: true),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

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
                'Ask Anything',
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

        // Chat area
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // User bubble
              _UserBubble(text: 'What is my interview schedule next week?'),
              const SizedBox(height: 16),

              // AI reply
              _AiReply(
                intro: 'You have 2 interviews next week.',
                cards: [
                  _InterviewCard(
                    company: 'Interview with\nABC Corp',
                    date: 'Tue, 18 Jul',
                    time: '3:00 PM',
                    location: 'Conf. Room 2B',
                  ),
                  _InterviewCard(
                    company: 'XYZ Technologies',
                    date: 'Thu, 20 Jul',
                    time: '11:00 AM',
                    location: 'Online',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Second user bubble
              _UserBubble(text: 'Show me all screenshots related to payments this month'),
              const SizedBox(height: 16),

              // Second AI reply
              _PaymentsReply(),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Input bar
        Container(
          margin: EdgeInsets.only(bottom: bottom > 0 ? bottom : 8, left: 20, right: 20),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ask anything...',
                    hintStyle: TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF8E8E93),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.mic_none_rounded, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.arrow_upward_rounded, size: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  final String text;
  const _UserBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.68),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF007AFF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final String company;
  final String date;
  final String time;
  final String location;

  const _InterviewCard({
    required this.company,
    required this.date,
    required this.time,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3)),
            const SizedBox(height: 6),
            Text(date, style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
            Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
            Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93))),
          ],
        ),
      ),
    );
  }
}

class _AiReply extends StatelessWidget {
  final String intro;
  final List<_InterviewCard> cards;

  const _AiReply({required this.intro, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(intro, style: const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E))),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: cards
              .expand((c) => [c, const SizedBox(width: 10)])
              .take(cards.length * 2 - 1)
              .toList(),
        ),
      ],
    );
  }
}

class _PaymentsReply extends StatelessWidget {
  const _PaymentsReply();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Here are your payments in July.',
            style: TextStyle(fontSize: 14, color: Color(0xFF1C1C1E))),
        const SizedBox(height: 10),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.6,
          children: const [
            _PaymentTile(label: 'W-Fi', amount: '₹2,500', name: 'Paid to Zylker', date: '17 Jul • 1:42 PM'),
            _PaymentTile(label: 'Gym Membership', amount: '₹3,999', name: '', date: '15 Jul'),
            _PaymentTile(label: '', amount: '₹1,240', name: 'Electricity Bill', date: '12 Jul'),
            _PaymentTile(label: '', amount: '₹899', name: 'Amazon Purchase', date: '8 Jul'),
          ],
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String label;
  final String amount;
  final String name;
  final String date;

  const _PaymentTile({
    required this.label,
    required this.amount,
    required this.name,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (label.isNotEmpty)
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          if (name.isNotEmpty)
            Text(name, style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
          Text(date, style: const TextStyle(fontSize: 10, color: Color(0xFF8E8E93))),
        ],
      ),
    );
  }
}