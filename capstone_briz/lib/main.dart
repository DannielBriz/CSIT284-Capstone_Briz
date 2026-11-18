import 'package:flutter/material.dart';
import 'package:capstone_briz/screens/home_screen.dart';

void main() {
  runApp(const SchoolEventRsvpApp());
}

class SchoolEventRsvpApp extends StatelessWidget {
  const SchoolEventRsvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Events',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BDB),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F7FB),
          foregroundColor: Color(0xFF202033),
          centerTitle: false,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
