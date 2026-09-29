import 'package:flutter/material.dart';
import 'screens/splash.dart';
import 'theme.dart';

void main() => runApp(const MemoryBankApp());

class MemoryBankApp extends StatelessWidget {
  const MemoryBankApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'MemoryBank',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: N.bg,
          colorScheme: ColorScheme.fromSeed(seedColor: N.yellow),
          textSelectionTheme: const TextSelectionThemeData(cursorColor: N.ink),
        ),
        home: const SplashScreen(),
      );
}
