
import '../models/event.dart';

final List<Event> dummyEvents = [
  Event(
    id: 'e1',
    title: 'Flutter Development Workshop',
    description:
        'Learn the fundamentals of Flutter and create your first mobile application with fellow students.',
    venue: 'Computer Laboratory 1',
    date: DateTime(2026, 12, 3),
    time: '9:00 AM',
    attendeeCount: 32,
    category: 'Workshop',
    imageUrl: '',
  ),
  Event(
    id: 'e2',
    title: 'Campus Sports Fest',
    description:
        'Join fellow students for a fun-filled day of sports, games, and friendly competition.',
    venue: 'University Gymnasium',
    date: DateTime(2026, 12, 8),
    time: '8:00 AM',
    attendeeCount: 85,
    category: 'Sports',
    imageUrl: '',
  ),
  Event(
    id: 'e3',
    title: 'Student Leadership Seminar',
    description:
        'Discover leadership skills, teamwork strategies, and ways to become an active student leader.',
    venue: 'Audio Visual Room',
    date: DateTime(2026, 12, 12),
    time: '1:00 PM',
    attendeeCount: 46,
    category: 'Seminar',
    imageUrl: '',
  ),
  Event(
    id: 'e4',
    title: 'Tech Innovation Expo',
    description:
        'Explore student projects, creative technologies, and innovative solutions developed by students.',
    venue: 'University Main Hall',
    date: DateTime(2027, 1, 15),
    time: '10:00 AM',
    attendeeCount: 58,
    category: 'Exhibition',
    imageUrl: '',
  ),
];
