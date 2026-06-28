import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../models/mock_data.dart';
import '../widgets/shared_widgets.dart';
import '../services/memory_service.dart';

// ════════════════════════════════════════════
//  1. Splash Screen
// ════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _slideCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  late Animation<double> _btnFade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _slideCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
    _btnFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _fadeCtrl.forward();
      _slideCtrl.forward();
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    // TODO: hook to auth check; navigate to onboarding or home
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const FeaturesScreen(),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _onSignIn() {
    // TODO: navigate to login/sign-in screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: Stack(
          children: [
            // Background image area (boilerplate camera lens visual)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF0A0810),
                    child: Center(
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppGradients.orb,
                        ),
                        child: const Icon(
                          Icons.camera_enhance,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Dark gradient overlay at bottom of image
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Color(0xFF0D0B14)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 0, 28, 48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppGradients.primary.createShader(bounds),
                          child: const Text(
                            'Everything\nyou capture,\nnever slips.',
                            style: AppTextStyles.displayLarge,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'MemoryLens automatically captures, organizes and reminds you of what matters.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 32),
                        FadeTransition(
                          opacity: _btnFade,
                          child: GradientButton(
                            label: 'Get Started',
                            onTap: _onGetStarted,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: GestureDetector(
                            onTap: _onSignIn,
                            child: RichText(
                              text: const TextSpan(
                                text: 'Already have an account? ',
                                style: AppTextStyles.bodyMedium,
                                children: [
                                  TextSpan(
                                    text: 'Sign in',
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  2. Features Onboarding Screen
// ════════════════════════════════════════════
class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final List<FeatureItem> _features = MockData.features;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onSkip() {
    // TODO: skip onboarding
    _navigateNext();
  }

  void _onNext() {
    _navigateNext();
  }

  void _navigateNext() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const PersonalizeScreen(),
        transitionsBuilder: (_, a, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  IconData _iconFor(String key) {
    switch (key) {
      case 'camera':
        return Icons.camera_alt_outlined;
      case 'grid':
        return Icons.grid_view_rounded;
      case 'bell':
        return Icons.notifications_outlined;
      case 'chat':
        return Icons.auto_awesome_outlined;
      default:
        return Icons.star_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  ShaderMask(
                    shaderCallback: (b) => AppGradients.primary.createShader(b),
                    child: const Text(
                      'Your second\nbrain for\nreal life.',
                      style: AppTextStyles.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Feature grid
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _features.length,
                      itemBuilder: (_, i) {
                        final f = _features[i];
                        return _FeatureCard(
                          icon: _iconFor(f.icon),
                          title: f.title,
                          description: f.description,
                          delay: Duration(milliseconds: 100 * i),
                        );
                      },
                    ),
                  ),

                  // Dots + arrow
                  Row(
                    children: [
                      _Dot(active: false),
                      const SizedBox(width: 6),
                      _Dot(active: true),
                      const SizedBox(width: 6),
                      _Dot(active: false),
                      const Spacer(),
                      AnimatedTap(
                        onTap: _onNext,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppGradients.primary,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Skip
            Positioned(
              top: 56,
              right: 24,
              child: GestureDetector(
                onTap: _onSkip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Duration delay;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () {
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
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: AppColors.primaryLight, size: 20),
              ),
              const Spacer(),
              Text(widget.title, style: AppTextStyles.headingMedium.copyWith(fontSize: 15)),
              const SizedBox(height: 4),
              Text(widget.description, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.textHint,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  3. Personalize Screen
// ════════════════════════════════════════════
class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPersona = 'professional';
  final Set<String> _selectedPriorities = {'work'};

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final List<PersonaOption> _personas = MockData.personas;
  final List<PriorityOption> _priorities = MockData.priorities;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onContinue() {
    // TODO: pass selectedPersona + selectedPriorities to next screen / API
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, a, __) => const ProfileSetupScreen(),
        transitionsBuilder: (_, a, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  children: List.generate(4, (i) => Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: i <= 1 ? AppColors.primary : AppColors.textHint,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 32),

                const Text(
                  "Let's personalize\nyour experience",
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'This helps us show what matters most to you.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                // I am
                const Text('I am', style: AppTextStyles.label),
                const SizedBox(height: 12),
                Row(
                  children: _personas.map((p) {
                    final sel = _selectedPersona == p.id;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPersona = p.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: p != _personas.last ? 10 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary.withOpacity(0.2) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.cardBorder,
                              width: sel ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                p.label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sel ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                              if (sel) ...[
                                const SizedBox(height: 4),
                                const Icon(Icons.check, size: 14, color: AppColors.primaryLight),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Priorities
                const Text(
                  'What do you want to give priority to?',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: _priorities.map((pr) {
                      final sel = _selectedPriorities.contains(pr.id);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (sel) {
                              _selectedPriorities.remove(pr.id);
                            } else {
                              _selectedPriorities.add(pr.id);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.primary.withOpacity(0.12) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.cardBorder,
                              width: sel ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                pr.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: sel ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                              const Spacer(),
                              if (sel)
                                const Icon(Icons.check, size: 16, color: AppColors.primaryLight),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                GradientButton(label: 'Continue', onTap: _onContinue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════
//  4. Profile Setup Screen
// ════════════════════════════════════════════
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _autoCapture = true;
  bool _isLoading = false;

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  final _service = MemoryService();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    _cityCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onStartUsing() async {
    setState(() => _isLoading = true);
    // TODO: validate + call API
    await _service.saveUserProfile(
      name: _nameCtrl.text,
      email: _emailCtrl.text,
      dob: _dobCtrl.text,
      city: _cityCtrl.text,
      persona: 'professional',
      priorities: ['work'],
      autoCapture: _autoCapture,
    );
    setState(() => _isLoading = false);
    if (!mounted) return;
    // TODO: navigate to main shell
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fade,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress
                Row(
                  children: List.generate(4, (i) => Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: i <= 3 ? AppColors.primary : AppColors.textHint,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 32),

                const Text('Almost there!', style: AppTextStyles.displayMedium),
                const SizedBox(height: 6),
                const Text(
                  'Tell us a few basics to get started.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                _ProfileField(label: 'Your name', controller: _nameCtrl, hint: 'Rohan Sharma'),
                const SizedBox(height: 14),
                _ProfileField(label: 'Email', controller: _emailCtrl, hint: 'rohan@email.com', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 14),
                _ProfileField(
                  label: 'Date of birth',
                  controller: _dobCtrl,
                  hint: '12 May 1990',
                  suffix: const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textMuted),
                  readOnly: true,
                  onTap: () async {
                    // TODO: show date picker
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(1990, 5, 12),
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.dark(primary: AppColors.primary),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      _dobCtrl.text =
                          '${picked.day} ${_monthName(picked.month)} ${picked.year}';
                    }
                  },
                ),
                const SizedBox(height: 14),
                _ProfileField(label: 'City', controller: _cityCtrl, hint: 'Bengaluru, India'),
                const SizedBox(height: 24),

                // Auto Capture toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Enable Auto Capture',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Detect screenshots and save automatically.',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _autoCapture = !_autoCapture),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 48,
                          height: 28,
                          decoration: BoxDecoration(
                            color: _autoCapture ? AppColors.primary : AppColors.textHint,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 250),
                            alignment: _autoCapture ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 22,
                              height: 22,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                GradientButton(
                  label: 'Start using MemoryLens',
                  onTap: _onStartUsing,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _monthName(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m - 1];
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════
//  Main Shell (Bottom Nav)
// ════════════════════════════════════════════
// Import here to avoid circular deps — placed in this file for convenience
import '../screens/capture_screen.dart';
import '../screens/all_screen.dart';
import '../screens/ask_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CaptureScreen(),
    AllScreen(),
    AskScreen(),
  ];

  void _onTabTap(int i) {
    // TODO: can add tab-specific logic here
    setState(() => _currentIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, a) => FadeTransition(opacity: a, child: child),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.camera_alt_outlined, label: 'Capture', index: 0, currentIndex: _currentIndex, onTap: _onTabTap),
                _NavItem(icon: Icons.grid_view_rounded, label: 'All', index: 1, currentIndex: _currentIndex, onTap: _onTabTap),
                _NavItem(icon: Icons.auto_awesome_outlined, label: 'Ask', index: 2, currentIndex: _currentIndex, onTap: _onTabTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1, end: 0.85).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sel = widget.index == widget.currentIndex;
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap(widget.index);
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: sel ? AppColors.primaryLight : AppColors.textMuted,
              ),
              const SizedBox(height: 4),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: sel ? AppColors.primaryLight : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}