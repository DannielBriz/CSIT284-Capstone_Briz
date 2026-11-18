
import 'package:flutter/material.dart';
import '../data/dummy_events.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 12),
          Text(
            'Campus Events',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover what is happening around campus.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.event_available_outlined),
              const SizedBox(width: 8),
              Text(
                '${dummyEvents.length} upcoming events',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...dummyEvents.map(
            (event) => EventCard(event: event),
          ),
        ],
      ),
    );
  }
}

