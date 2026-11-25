import 'package:flutter/material.dart';

import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  final void Function(Event event) onOpenEvent;

  EventsScreen({
    super.key,
    required this.onOpenEvent,
  });

  final EventService _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: _eventService.getEvents(),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error loading events:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // No events in Firestore
        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No events available yet.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Events added to Firestore will appear here.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Display Firestore events
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];

            return EventCard(
              event: event,
              onTap: () => onOpenEvent(event),
            );
          },
        );
      },
    );
  }
}