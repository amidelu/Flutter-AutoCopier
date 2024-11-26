import 'package:flutter/material.dart';
import 'bulk_input_screen.dart';

void main() {
  @pragma("vm:entry-point")
  void accessibilityOverlay() {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Copier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BulkInputScreen(),
    );
  }
}
