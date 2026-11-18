import '../models/event.dart';

final List<Event> dummyEvents = [
  // EVENT 1
  Event(
    id: 'e1',
    title: 'Flutter Development Workshop',
    description:
        'Learn the basics of Flutter app development and build your first mobile application.',
    dateTime: DateTime.now().add(const Duration(days: 2)),
    venue: 'Computer Laboratory 1',
    category: 'Technology',
    attendeeCount: 24,
  ),

  // EVENT 2
  Event(
    id: 'e2',
    title: 'Campus Sports Fest',
    description:
        'Join exciting sports activities, compete with fellow students, and enjoy a day of friendly competition.',
    dateTime: DateTime.now().add(const Duration(days: 5)),
    venue: 'University Gymnasium',
    category: 'Sports',
    attendeeCount: 86,
  ),

  // EVENT 3
  Event(
    id: 'e3',
    title: 'Student Leadership Seminar',
    description:
        'Develop your leadership, communication, teamwork, and decision-making skills.',
    dateTime: DateTime.now().add(const Duration(days: 8)),
    venue: 'University Auditorium',
    category: 'Leadership',
    attendeeCount: 42,
  ),

  // EVENT 4
  Event(
    id: 'e4',
    title: 'Technology Innovation Expo',
    description:
        'Explore innovative student projects, creative technologies, and exciting digital solutions.',
    dateTime: DateTime.now().add(const Duration(days: 12)),
    venue: 'University Activity Center',
    category: 'Academic',
    attendeeCount: 57,
  ),

  // EVENT 5
  Event(
    id: 'e5',
    title: 'Career and Job Fair',
    description:
        'Meet company representatives, explore career opportunities, and learn about internship programs.',
    dateTime: DateTime.now().add(const Duration(days: 15)),
    venue: 'Main Campus Hall',
    category: 'Career',
    attendeeCount: 73,
  ),

  // EVENT 6
  Event(
    id: 'e6',
    title: 'Campus Music Festival',
    description:
        'Enjoy live performances, student bands, and a celebration of music and creativity.',
    dateTime: DateTime.now().add(const Duration(days: 18)),
    venue: 'Open Grounds',
    category: 'Entertainment',
    attendeeCount: 120,
  ),

  // EVENT 7
  Event(
    id: 'e7',
    title: 'Community Outreach Program',
    description:
        'Participate in community service activities and make a positive difference in the local community.',
    dateTime: DateTime.now().add(const Duration(days: 21)),
    venue: 'Community Extension Center',
    category: 'Community',
    attendeeCount: 35,
  ),

  // EVENT 8
  Event(
    id: 'e8',
    title: 'Cybersecurity Awareness Seminar',
    description:
        'Learn about online safety, cyber threats, data privacy, and responsible internet usage.',
    dateTime: DateTime.now().add(const Duration(days: 24)),
    venue: 'Computer Laboratory 2',
    category: 'Technology',
    attendeeCount: 48,
  ),

  // EVENT 9
  Event(
    id: 'e9',
    title: 'Photography Workshop',
    description:
        'Discover photography techniques, composition, lighting, and how to capture memorable moments.',
    dateTime: DateTime.now().add(const Duration(days: 27)),
    venue: 'Media Arts Room',
    category: 'Arts',
    attendeeCount: 29,
  ),

  // EVENT 10
  Event(
    id: 'e10',
    title: 'Student Wellness Day',
    description:
        'Take part in relaxing activities, wellness sessions, and interactive activities promoting student well-being.',
    dateTime: DateTime.now().add(const Duration(days: 30)),
    venue: 'Student Wellness Center',
    category: 'Wellness',
    attendeeCount: 64,
  ),
];