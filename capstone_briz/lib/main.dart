import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/event_seed.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('MAIN: Initializing Firebase...');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('MAIN: Firebase initialized successfully.');

    // Authenticate before starting the app.
    debugPrint('MAIN: Signing in user...');

    final user = await AuthService.ensureSignedIn();

    debugPrint('MAIN: Authentication complete.');
    debugPrint('MAIN: User UID = ${user.uid}');
    debugPrint('MAIN: Signed in = ${AuthService.isSignedIn}');

    // Seed sample events.
    debugPrint('MAIN: Before seeder');

    await EventSeed.seedEvents();

    debugPrint('MAIN: After seeder');

    // Start the app.
    runApp(const SchoolEventRsvpApp());
  } catch (e, stackTrace) {
    debugPrint('MAIN ERROR: $e');
    debugPrint('$stackTrace');

    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'App initialization failed.\n\n$e',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SchoolEventRsvpApp extends StatelessWidget {
  const SchoolEventRsvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Event RSVP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}