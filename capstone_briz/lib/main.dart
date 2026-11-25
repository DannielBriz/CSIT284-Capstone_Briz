
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/event_seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('MAIN: Initializing Firebase...');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print('MAIN: Firebase initialized successfully.');
  print('MAIN: Before seeder');

  await EventSeed.seedEvents();

  print('MAIN: After seeder');

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
      home: const HomeScreen(),
    );
  }
}
