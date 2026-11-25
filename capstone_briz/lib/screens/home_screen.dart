import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/bottom_navigation.dart';
import 'events_screen.dart';
import 'event_details_screen.dart';
import 'my_events_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final Set<String> _registeredEventIds = {};

  final EventService _eventService = EventService();

  void _toggleRsvp(Event event, bool isRegistered) {
    setState(() {
      if (isRegistered) {
        _registeredEventIds.add(event.id);
      } else {
        _registeredEventIds.remove(event.id);
      }
    });
  }

  void _openEvent(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EventDetailsScreen(
          event: event,
          isRegistered: _registeredEventIds.contains(event.id),
          onRsvpChanged: (isRegistered) {
            _toggleRsvp(event, isRegistered);
          },
        ),
      ),
    );
  }

  void _cancelRsvp(Event event) {
    setState(() {
      _registeredEventIds.remove(event.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('RSVP cancelled for ${event.title}'),
      ),
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: _eventService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Unable to load events from Firebase.\n\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final firestoreEvents = snapshot.data ?? [];

        // Registered events now come from Firestore.
        final registeredEvents = firestoreEvents
            .where(
              (event) => _registeredEventIds.contains(event.id),
            )
            .toList();

        final pages = [
          EventsScreen(
            onOpenEvent: _openEvent,
          ),
          MyEventsScreen(
            registeredEvents: registeredEvents,
            onOpenEvent: _openEvent,
            onCancelRsvp: _cancelRsvp,
          ),
        ];

        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigation(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _selectPage,
          ),
        );
      },
    );
  }
}