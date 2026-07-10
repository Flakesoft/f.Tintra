import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FTintraApp());
}

class FTintraApp extends StatelessWidget {
  const FTintraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'f.Tintra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}