
import '../models/event.dart';

final List<Event> dummyEvents = [
  Event(
    id: 'e1',
    title: 'Flutter Development Workshop',
    description:
        'Learn the basics of Flutter and create your first mobile application in this hands-on workshop.',
    dateTime: DateTime.now().add(const Duration(days: 2)),
    venue: 'Computer Laboratory 1',
    category: 'Technology',
    attendeeCount: 24,
  ),
  Event(
    id: 'e2',
    title: 'Campus Sports Fest',
    description:
        'Join your fellow students for a fun-filled day of sports, games, and friendly competition.',
    dateTime: DateTime.now().add(const Duration(days: 5)),
    venue: 'University Gymnasium',
    category: 'Sports',
    attendeeCount: 86,
  ),
  Event(
    id: 'e3',
    title: 'Student Leadership Seminar',
    description:
        'Develop leadership, teamwork, communication, and decision-making skills.',
    dateTime: DateTime.now().add(const Duration(days: 8)),
    venue: 'Auditorium',
    category: 'Leadership',
    attendeeCount: 42,
  ),
  Event(
    id: 'e4',
    title: 'Technology Innovation Expo',
    description:
        'Explore student projects, creative ideas, and innovative technology solutions.',
    dateTime: DateTime.now().add(const Duration(days: 12)),
    venue: 'University Activity Center',
    category: 'Academic',
    attendeeCount: 57,
  ),
];
