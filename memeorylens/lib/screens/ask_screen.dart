import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import '../services/memory_service.dart';
import '../widgets/shared_widgets.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> with TickerProviderStateMixin {
  final _queryCtrl = TextEditingController();
  bool _isTyping = false;
  bool _isLoading = false;
  String? _response;

  late AnimationController _orbCtrl;
  late AnimationController _fadeCtrl;
  late Animation<double> _orbPulse;
  late Animation<double> _fade;

  final _service = MemoryService();
  final List<AskSuggestion> _suggestions = MockData.askSuggestions;

  @override
  void initState() {
    super.initState();
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _orbPulse = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _orbCtrl, curve: Curves.easeInOut),
    );

    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();

    _queryCtrl.addListener(() {
      setState(() => _isTyping = _queryCtrl.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    _orbCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onAsk(String query) async {
    if (query.trim().isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
      _response = null;
    });
    // TODO: call real API
    final answer = await _service.askQuestion(query);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _response = answer;
    });
  }

  void _onSuggestionTap(AskSuggestion s) {
    _queryCtrl.text = s.question;
    _onAsk(s.question);
  }

  void _onHistoryTap() {
    // TODO: open ask history screen
  }

  void _onVoiceTap() {
    // TODO: start voice input
  }

  IconData _suggestionIcon(String key) {
    switch (key) {
      case 'calendar':
        return Icons.event_outlined;
      case 'payment':
        return Icons.currency_rupee;
      case 'travel':
        return Icons.flight_outlined;
      default:
        return Icons.auto_awesome_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    const Text('Ask', style: AppTextStyles.headingLarge),
                    const Spacer(),
                    AnimatedTap(
                      onTap: _onHistoryTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.history, color: AppColors.textSecondary, size: 22),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    children: [
                      // Orb
                      ScaleTransition(
                        scale: _orbPulse,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.orb,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 52,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (!_isLoading && _response == null) ...[
                        const Text(
                          'Ask anything about\nyour memories',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingLarge,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Find info, get summaries,\nor answers instantly.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 32),

                        // Suggestions
                        ..._suggestions.map((s) => _SuggestionChip(
                          suggestion: s,
                          icon: _suggestionIcon(s.iconKey),
                          onTap: () => _onSuggestionTap(s),
                        )),
                      ],

                      if (_isLoading) ...[
                        const SizedBox(height: 24),
                        const CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 16),
                        const Text('Searching your memories...', style: AppTextStyles.bodyMedium),
                      ],

                      if (_response != null) ...[
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            _response!,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => setState(() => _response = null),
                          child: const Text(
                            'Ask another question',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              // Input bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _queryCtrl,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        textInputAction: TextInputAction.send,
                        onSubmitted: _onAsk,
                        decoration: InputDecoration(
                          hintText: 'Ask anything...',
                          filled: true,
                          fillColor: AppColors.inputBg,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          suffixIcon: AnimatedTap(
                            onTap: _onVoiceTap,
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.mic, color: AppColors.textMuted, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedTap(
                      onTap: () => _onAsk(_queryCtrl.text),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _isTyping ? AppGradients.primary : null,
                          color: _isTyping ? null : AppColors.card,
                          border: _isTyping ? null : Border.all(color: AppColors.cardBorder),
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: _isTyping ? Colors.white : AppColors.textMuted,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final AskSuggestion suggestion;
  final IconData icon;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.suggestion,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: AppColors.primaryLight),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                suggestion.question,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}