import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/calculator_screen.dart';
import 'providers/calculator_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: MaterialApp(
        title: '灵悦计算器 · 优化版',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xFFE2E8F0),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF3B82F6),
            secondary: Color(0xFF6B7280),
            surface: Colors.white,
          ),
          fontFamily: 'Inter',
        ),
        home: const CalculatorScreen(),
      ),
    );
  }
}
