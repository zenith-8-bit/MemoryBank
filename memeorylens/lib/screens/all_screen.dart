import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import '../widgets/shared_widgets.dart';
import '../services/memory_service.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen>
    with SingleTickerProviderStateMixin {
  bool _autoCaptureOn = true;
  List<CaptureItem> _captures = [];
  bool _loading = true;

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _service = MemoryService();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _loadCaptures();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCaptures() async {
    // TODO: replace with real API
    final data = await _service.fetchCaptures();
    if (!mounted) return;
    setState(() {
      _captures = data;
      _loading = false;
    });
    _fadeCtrl.forward();
  }

  void _onSettingsTap() {
    // TODO: open settings screen / sheet
  }

  void _onSeeAll() {
    // TODO: navigate to full captures list
  }

  void _onCaptureFabTap() {
    // TODO: trigger manual capture (open camera / screenshot picker)
  }

  void _onCaptureItemTap(CaptureItem item) {
    // TODO: open capture detail screen
  }

  void _onToggleAutoCapture(bool val) async {
    setState(() => _autoCaptureOn = val);
    await _service.toggleAutoCapture(val);
  }

  Color _typeColor(CaptureType t) {
    switch (t) {
      case CaptureType.bill:
        return AppColors.accentBlue;
      case CaptureType.shopping:
        return AppColors.accentRed;
      case CaptureType.health:
        return AppColors.accentGreen;
      case CaptureType.document:
        return AppColors.textSecondary;
      case CaptureType.screenshot:
        return AppColors.primaryLight;
      case CaptureType.receipt:
        return AppColors.accentYellow;
    }
  }

  String _typeLabel(CaptureType t) {
    switch (t) {
      case CaptureType.bill:
        return 'Bill';
      case CaptureType.shopping:
        return 'Shopping';
      case CaptureType.health:
        return 'Health';
      case CaptureType.document:
        return 'Doc';
      case CaptureType.screenshot:
        return 'Screenshot';
      case CaptureType.receipt:
        return 'Receipt';
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day} ${_month(d.month)}${d.hour > 0 ? ', ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}' : ''}';

  String _month(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
              : CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      pinned: false,
                      floating: true,
                      backgroundColor: AppColors.background,
                      titleSpacing: 24,
                      title: const Text('Capture', style: AppTextStyles.headingLarge),
                      actions: [
                        AnimatedTap(
                          onTap: _onSettingsTap,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: const Icon(Icons.settings_outlined, size: 20, color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Auto capture banner
                            _AutoCaptureBanner(
                              isOn: _autoCaptureOn,
                              onToggle: _onToggleAutoCapture,
                            ),
                            const SizedBox(height: 28),

                            // Recent captures header
                            Row(
                              children: [
                                const Text('Recent Captures', style: AppTextStyles.headingMedium),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _onSeeAll,
                                  child: const Text(
                                    'See all',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Captures grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                              itemCount: _captures.length,
                              itemBuilder: (_, i) {
                                return _CaptureCard(
                                  item: _captures[i],
                                  typeLabel: _typeLabel(_captures[i].type),
                                  typeColor: _typeColor(_captures[i].type),
                                  dateStr: _formatDate(_captures[i].capturedAt),
                                  onTap: () => _onCaptureItemTap(_captures[i]),
                                  animDelay: Duration(milliseconds: 60 * i),
                                );
                              },
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),

      // FAB capture button
      floatingActionButton: AnimatedTap(
        onTap: _onCaptureFabTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppGradients.primary,
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _AutoCaptureBanner extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;

  const _AutoCaptureBanner({required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOn ? AppColors.primary.withOpacity(0.08) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOn ? AppColors.primary.withOpacity(0.3) : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOn ? AppColors.accentGreen : AppColors.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto capture is ${isOn ? 'ON' : 'OFF'}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "We'll save screenshots\nand important info.",
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Boilerplate document preview stack
          SizedBox(
            width: 64,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  child: BoilerplateImage(
                    width: 42,
                    height: 50,
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.surfaceElevated,
                    icon: Icons.description_outlined,
                  ),
                ),
                BoilerplateImage(
                  width: 42,
                  height: 50,
                  borderRadius: BorderRadius.circular(6),
                  color: AppColors.cardBorder,
                  icon: Icons.image_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaptureCard extends StatefulWidget {
  final CaptureItem item;
  final String typeLabel;
  final Color typeColor;
  final String dateStr;
  final VoidCallback onTap;
  final Duration animDelay;

  const _CaptureCard({
    required this.item,
    required this.typeLabel,
    required this.typeColor,
    required this.dateStr,
    required this.onTap,
    required this.animDelay,
  });

  @override
  State<_CaptureCard> createState() => _CaptureCardState();
}

class _CaptureCardState extends State<_CaptureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
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
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.surfaceElevated,
                      child: Icon(
                        _iconFor(widget.item.type),
                        size: 40,
                        color: widget.typeColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),

                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.item.amount != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.item.amount!,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.typeColor,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(widget.typeLabel, style: AppTextStyles.bodySmall.copyWith(color: widget.typeColor)),
                          const Spacer(),
                          Text(widget.dateStr, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(CaptureType t) {
    switch (t) {
      case CaptureType.bill:
        return Icons.receipt_long;
      case CaptureType.shopping:
        return Icons.shopping_bag_outlined;
      case CaptureType.health:
        return Icons.favorite_border;
      case CaptureType.document:
        return Icons.description_outlined;
      case CaptureType.screenshot:
        return Icons.screenshot_monitor_outlined;
      case CaptureType.receipt:
        return Icons.receipt_outlined;
    }
  }
}