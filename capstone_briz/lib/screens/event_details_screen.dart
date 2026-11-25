
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event.dart';
import 'edit_event_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;
  final bool isRegistered;
  final ValueChanged<bool> onRsvpChanged;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isRegistered,
    required this.onRsvpChanged,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late bool _isRegistered;
  late Event _event;

  @override
  void initState() {
    super.initState();
    _isRegistered = widget.isRegistered;
    _event = widget.event;
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];

    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$weekday, $month ${date.day}, ${date.year} • $hour:$minute $period';
  }

  IconData _getCategoryIcon() {
    switch (_event.category.toLowerCase()) {
      case 'technology':
        return Icons.computer;
      case 'sports':
        return Icons.sports_basketball;
      case 'leadership':
        return Icons.groups;
      case 'academic':
        return Icons.school;
      default:
        return Icons.event;
    }
  }

  void _toggleRsvp() {
    setState(() {
      _isRegistered = !_isRegistered;
    });

    widget.onRsvpChanged(_isRegistered);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isRegistered
              ? 'You have successfully RSVP\'d!'
              : 'Your RSVP has been cancelled.',
        ),
      ),
    );
  }

  Future<void> _editEvent() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: _event),
      ),
    );

    if (result == true && mounted) {
      // Fetch the updated event from Firestore.
      try {
        final document = await FirebaseFirestore.instance
            .collection('events')
            .doc(_event.id)
            .get();

        if (document.exists && document.data() != null) {
          final data = document.data()!;

          setState(() {
            _event = Event(
              id: document.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              dateTime: (data['dateTime'] as Timestamp).toDate(),
              venue: data['venue'] ?? '',
              category: data['category'] ?? '',
              attendeeCount: data['attendeeCount'] ?? 0,
            );
          });
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event details refreshed successfully!'),
          ),
        );
      } catch (error) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event saved, but refresh failed: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = _event;
    final theme = Theme.of(context);
    final attendeeCount =
        event.attendeeCount + (_isRegistered ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            onPressed: _editEvent,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Event',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event banner
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getCategoryIcon(),
                size: 90,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Category
            Text(
              event.category.toUpperCase(),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              event.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Date and time
            _buildInfoRow(
              Icons.calendar_month,
              'Date & Time',
              _formatDate(event.dateTime),
            ),
            const SizedBox(height: 16),

            // Venue
            _buildInfoRow(
              Icons.location_on,
              'Venue',
              event.venue,
            ),
            const SizedBox(height: 16),

            // Attendees
            _buildInfoRow(
              Icons.people,
              'Attendees',
              '$attendeeCount students attending',
            ),
            const SizedBox(height: 28),

            const Divider(),
            const SizedBox(height: 16),

            // About event
            Text(
              'About this event',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              event.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // RSVP button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _toggleRsvp,
                icon: Icon(
                  _isRegistered
                      ? Icons.check_circle
                      : Icons.event_available,
                ),
                label: Text(
                  _isRegistered ? 'Cancel RSVP' : 'RSVP to Event',
                  style: const TextStyle(fontSize: 16),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _isRegistered
                      ? Colors.red.shade400
                      : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                _isRegistered
                    ? 'You are registered for this event!'
                    : 'Join other students at this event.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
