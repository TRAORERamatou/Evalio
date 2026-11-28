import 'package:flutter/material.dart';
import 'features/focus/presentation/focus_test_screen.dart';

class EvalioApp extends StatelessWidget {
  const EvalioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evalio',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF1B5E8C)),
      home: const FocusTestScreen(),
    );
  }
}
