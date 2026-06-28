import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding/onboarding_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MemoryLensApp());
}

class MemoryLensApp extends StatelessWidget {
  const MemoryLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MemoryLens',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // Start at splash; swap to MainShell after onboarding / auth check
      home: const SplashScreen(),
    );
  }
}