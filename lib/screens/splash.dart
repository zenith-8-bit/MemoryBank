import 'package:flutter/material.dart';
import '../theme.dart';
import 'shell.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Spacer(),
              Center(
                child: Transform.rotate(
                  angle: -0.06,
                  child: const NeoBox(color: N.pink, shadow: 8, padding: EdgeInsets.all(28), child: Icon(Icons.psychology, size: 96, color: N.ink)),
                ),
              ),
              const SizedBox(height: 36),
              const Text('MEMORY\nBANK', textAlign: TextAlign.center, style: TextStyle(fontSize: 52, height: 1, fontWeight: FontWeight.w900, color: N.ink)),
              const SizedBox(height: 20),
              const NeoBox(color: N.yellow, child: Text('Capture today.\nFind tomorrow.', textAlign: TextAlign.center, style: N.h2)),
              const Spacer(),
              NeoButton('Get Started', icon: Icons.arrow_forward, onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Shell()))),
            ]),
          ),
        ),
      );
}
