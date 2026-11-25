
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event.dart';
import '../services/event_service.dart';
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
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'technology':
        return Icons.computer;
      case 'sports':
        return Icons.sports;
      case 'leadership':
        return Icons.groups;
      case 'career':
        return Icons.work;
      case 'academic':
        return Icons.school;
      case 'community':
        return Icons.volunteer_activism;
      case 'competition':
        return Icons.emoji_events;
      case 'wellness':
        return Icons.favorite;
      default:
        return Icons.event;
    }
  }

  Future<void> _editEvent() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: _event),
      ),
    );

    if (result != true || !mounted) return;

    try {
      final document = await FirebaseFirestore.instance
          .collection('events')
          .doc(_event.id)
          .get();

      if (!document.exists || document.data() == null) return;

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
          content: Text('Could not refresh event: $error'),
        ),
      );
    }
  }

  Future<void> _deleteEvent() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text(
          'Are you sure you want to delete "${_event.title}"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    try {
      await EventService().deleteEvent(_event.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event deleted successfully!'),
        ),
      );

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete event: $error'),
        ),
      );
    }
  }

  void _toggleRsvp() {
    setState(() {
      _isRegistered = !_isRegistered;
    });

    widget.onRsvpChanged(_isRegistered);
  }

  @override
  Widget build(BuildContext context) {
    final event = _event;

    final formattedDate =
        '${event.dateTime.month}/${event.dateTime.day}/${event.dateTime.year}';

    final formattedTime =
        TimeOfDay.fromDateTime(event.dateTime).format(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
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
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _getCategoryIcon(event.category),
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            Chip(
              avatar: Icon(
                _getCategoryIcon(event.category),
                size: 18,
              ),
              label: Text(event.category),
            ),

            const SizedBox(height: 12),

            Text(
              event.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            // Event information
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              formattedDate,
            ),

            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.access_time,
              'Time',
              formattedTime,
            ),

            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.location_on,
              'Venue',
              event.venue,
            ),

            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.people,
              'Attendees',
              '${event.attendeeCount} students attending',
            ),

            const SizedBox(height: 24),

            Text(
              'About this Event',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 30),

            // Larger RSVP button
            SizedBox(
              width: double.infinity,
              height: 68,
              child: ElevatedButton.icon(
                onPressed: _toggleRsvp,
                icon: Icon(
                  _isRegistered
                      ? Icons.cancel_outlined
                      : Icons.check_circle_outline,
                  size: 28,
                ),
                label: Text(
                  _isRegistered
                      ? 'CANCEL RSVP'
                      : 'REGISTER FOR EVENT',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRegistered
                      ? Colors.red
                      : const Color(0xFF5B4BDB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Event management section moved below RSVP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'EVENT MANAGEMENT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Manage this event using the actions below.',
                  ),

                  const SizedBox(height: 18),

                  // Edit button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _editEvent,
                      icon: const Icon(
                        Icons.edit,
                        size: 26,
                      ),
                      label: const Text(
                        'EDIT EVENT',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B4BDB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Delete button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: _deleteEvent,
                      icon: const Icon(
                        Icons.delete_forever,
                        size: 26,
                      ),
                      label: const Text(
                        'DELETE EVENT',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
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
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
