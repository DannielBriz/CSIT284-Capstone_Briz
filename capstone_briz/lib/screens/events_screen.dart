import 'package:flutter/material.dart';
import '../data/dummy_events.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Campus Events',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover what is happening around campus.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${dummyEvents.length} upcoming events',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Display all campus events
          ...dummyEvents.map(
            (event) => EventCard(
              event: event,
              onTap: () {
                // Event details navigation will be added next.
              },
            ),
          ),
        ],
      ),
    );
  }
}