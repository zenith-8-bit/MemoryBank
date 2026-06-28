import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import '../services/memory_service.dart';
import '../widgets/shared_widgets.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen>
    with SingleTickerProviderStateMixin {
  PaymentCategory _selectedCategory = PaymentCategory.all;
  List<PaymentItem> _payments = [];
  bool _loading = true;

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _service = MemoryService();

  static const _categories = [
    (PaymentCategory.all, 'All'),
    (PaymentCategory.bills, 'Bills'),
    (PaymentCategory.subscriptions, 'Subscriptions'),
    (PaymentCategory.shopping, 'Shopping'),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _loadPayments();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPayments() async {
    final data = await _service.fetchPayments(category: _selectedCategory);
    if (!mounted) return;
    setState(() {
      _payments = data;
      _loading = false;
    });
    _fadeCtrl.forward();
  }

  void _onCategoryChange(PaymentCategory cat) {
    setState(() {
      _selectedCategory = cat;
      _loading = true;
    });
    _fadeCtrl.reset();
    _loadPayments();
  }

  void _onPaymentTap(PaymentItem item) {
    // TODO: open payment detail screen
  }

  void _onFilterTap() {
    // TODO: open filter/sort bottom sheet
  }

  double get _totalSpent {
    return _payments.fold(0, (sum, p) {
      final numStr = p.amount.replaceAll(RegExp(r'[₹,]'), '');
      return sum + (double.tryParse(numStr) ?? 0);
    });
  }

  // Group payments by month
  Map<String, List<PaymentItem>> get _grouped {
    final map = <String, List<PaymentItem>>{};
    for (final p in _payments) {
      final key = '${_monthName(p.date.month)} ${p.date.year}';
      map.putIfAbsent(key, () => []).add(p);
    }
    return map;
  }

  String _monthName(int m) {
    const months = ['January','February','March','April','May','June',
                    'July','August','September','October','November','December'];
    return months[m - 1];
  }

  String _shortDate(DateTime d) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[d.month - 1]} ${d.day}';
  }

  Color _iconBg(String label) {
    final colors = {
      'Z': AppColors.accentGreen,
      'G': AppColors.accentRed,
      'E': AppColors.accentBlue,
      'A': AppColors.accentOrange,
      'I': AppColors.primaryLight,
    };
    return (colors[label] ?? AppColors.primary).withOpacity(0.2);
  }

  Color _iconColor(String label) {
    final colors = {
      'Z': AppColors.accentGreen,
      'G': AppColors.accentRed,
      'E': AppColors.accentBlue,
      'A': AppColors.accentOrange,
      'I': AppColors.primaryLight,
    };
    return colors[label] ?? AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
                  ),
                  const Text('Payments', style: AppTextStyles.headingLarge),
                  const Spacer(),
                  AnimatedTap(
                    onTap: _onFilterTap,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.tune_rounded, color: AppColors.textSecondary, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // Month + total card
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('This Month (July)', style: AppTextStyles.bodySmall),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.textMuted),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${_totalSpent.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                            style: AppTextStyles.amount.copyWith(fontSize: 26),
                          ),
                          const SizedBox(height: 2),
                          const Text('Total spent', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    MiniSpendingBars(values: MockData.spendingBars),
                  ],
                ),
              ),
            ),

            // Category filter
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final (cat, label) = _categories[i];
                    final sel = _selectedCategory == cat;
                    return AnimatedTap(
                      onTap: () => _onCategoryChange(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel ? AppColors.primary : AppColors.card,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: sel ? AppColors.primary : AppColors.cardBorder),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: sel ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payments list grouped
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : FadeTransition(
                      opacity: _fade,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                        itemCount: grouped.length,
                        itemBuilder: (_, gi) {
                          final monthKey = grouped.keys.elementAt(gi);
                          final items = grouped[monthKey]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12, top: gi > 0 ? 20 : 0),
                                child: Text(
                                  monthKey,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                              ...items.asMap().entries.map((e) {
                                final p = e.value;
                                return _PaymentRow(
                                  item: p,
                                  iconBg: _iconBg(p.iconLabel),
                                  iconColor: _iconColor(p.iconLabel),
                                  dateStr: _shortDate(p.date),
                                  onTap: () => _onPaymentTap(p),
                                  animDelay: Duration(milliseconds: 40 * e.key),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentRow extends StatefulWidget {
  final PaymentItem item;
  final Color iconBg;
  final Color iconColor;
  final String dateStr;
  final VoidCallback onTap;
  final Duration animDelay;

  const _PaymentRow({
    required this.item,
    required this.iconBg,
    required this.iconColor,
    required this.dateStr,
    required this.onTap,
    required this.animDelay,
  });

  @override
  State<_PaymentRow> createState() => _PaymentRowState();
}

class _PaymentRowState extends State<_PaymentRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(widget.animDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: AnimatedTap(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                // Icon circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.item.iconLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.iconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title + account
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (widget.item.accountMasked != null) ...[
                        const SizedBox(height: 3),
                        Text(
                          widget.item.accountMasked!,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),

                // Amount + date + status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.item.amount, style: AppTextStyles.amountSmall),
                    const SizedBox(height: 4),
                    Text(widget.dateStr, style: AppTextStyles.bodySmall),
                    if (widget.item.isPaid) ...[
                      const SizedBox(height: 4),
                      StatusBadge(isPaid: widget.item.isPaid),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}