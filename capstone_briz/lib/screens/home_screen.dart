
import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/bottom_navigation.dart';
import 'events_screen.dart';
import 'event_details_screen.dart';
import 'my_events_screen.dart';
import 'add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final EventService _eventService = EventService();

  // =========================================================
  // RSVP: Register or cancel registration in Firestore
  // =========================================================
  Future<void> _toggleRsvp(Event event, bool isRegistered) async {
    if (isRegistered) {
      await _eventService.registerForEvent(event.id);
    } else {
      await _eventService.cancelRegistration(event.id);
    }
  }

  // =========================================================
  // Open Event Details
  // =========================================================
  void _openEvent(Event event, Set<String> registeredEventIds) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EventDetailsScreen(
          event: event,
          isRegistered: registeredEventIds.contains(event.id),

          // Return the Future so EventDetailsScreen can await it.
          onRsvpChanged: (isRegistered) {
            return _toggleRsvp(event, isRegistered);
          },
        ),
      ),
    );
  }

  // =========================================================
  // Cancel RSVP from My Events
  // =========================================================
  Future<void> _cancelRsvp(Event event) async {
    try {
      await _eventService.cancelRegistration(event.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration cancelled successfully.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to cancel registration: $e'),
        ),
      );
    }
  }

  // =========================================================
  // Bottom Navigation
  // =========================================================
  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // =========================================================
  // Add Event
  // =========================================================
  Future<void> _openAddEventScreen() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddEventScreen(),
      ),
    );
  }

  // =========================================================
  // UI
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: _eventService.getEvents(),
      builder: (context, eventSnapshot) {
        if (eventSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Unable to load events from Firebase.\n\n'
                  '${eventSnapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (eventSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final firestoreEvents = eventSnapshot.data ?? [];

        return StreamBuilder<Set<String>>(
          stream: _eventService.getRegisteredEventIds(),
          builder: (context, registrationSnapshot) {
            if (registrationSnapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Unable to load your registrations.\n\n'
                      '${registrationSnapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }

            if (registrationSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final registeredEventIds =
                registrationSnapshot.data ?? <String>{};

            final registeredEvents = firestoreEvents
                .where(
                  (event) => registeredEventIds.contains(event.id),
                )
                .toList();

            final pages = [
              EventsScreen(
                onOpenEvent: (event) {
                  _openEvent(event, registeredEventIds);
                },
              ),
              MyEventsScreen(
                registeredEvents: registeredEvents,
                onOpenEvent: (event) {
                  _openEvent(event, registeredEventIds);
                },
                onCancelRsvp: _cancelRsvp,
              ),
            ];

            return Scaffold(
              body: IndexedStack(
                index: _selectedIndex,
                children: pages,
              ),
              floatingActionButton: _selectedIndex == 0
                  ? FloatingActionButton.extended(
                      onPressed: _openAddEventScreen,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Event'),
                    )
                  : null,
              bottomNavigationBar: BottomNavigation(
                selectedIndex: _selectedIndex,
                onDestinationSelected: _selectPage,
              ),
            );
          },
        );
      },
    );
  }
}
