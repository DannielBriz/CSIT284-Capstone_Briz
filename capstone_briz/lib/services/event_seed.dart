import 'package:cloud_firestore/cloud_firestore.dart';

class EventSeed {
  static Future<void> seedEvents() async {
    final firestore = FirebaseFirestore.instance;
    final eventsCollection = firestore.collection('events');

    print('SEEDER: Starting Firestore seed...');

    try {
      // Read existing documents so we don't create duplicates.
      final existingSnapshot = await eventsCollection.get();

      final existingTitles = existingSnapshot.docs
          .map((doc) => doc.data()['title'] as String?)
          .whereType<String>()
          .toSet();

      print('SEEDER: Existing documents: ${existingSnapshot.docs.length}');

      final now = DateTime.now();

      final events = [
        {
          'title': 'Flutter Development Workshop',
          'description':
              'Learn Flutter mobile development fundamentals and build your first application.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 2))),
          'venue': 'Computer Laboratory 1',
          'category': 'Technology',
          'attendeeCount': 24,
        },
        {
          'title': 'Campus Sports Fest',
          'description':
              'Join different sports activities and support your fellow students.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 5))),
          'venue': 'University Gymnasium',
          'category': 'Sports',
          'attendeeCount': 86,
        },
        {
          'title': 'Student Leadership Seminar',
          'description':
              'Develop leadership, teamwork, and communication skills.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 8))),
          'venue': 'Auditorium',
          'category': 'Leadership',
          'attendeeCount': 42,
        },
        {
          'title': 'Technology Innovation Expo',
          'description':
              'Discover student innovations, projects, and new technologies.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 12))),
          'venue': 'University Activity Center',
          'category': 'Academic',
          'attendeeCount': 57,
        },
        {
          'title': 'Career and Job Fair',
          'description':
              'Explore career opportunities and connect with industry professionals.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 15))),
          'venue': 'Main Campus Hall',
          'category': 'Career',
          'attendeeCount': 73,
        },
        {
          'title': 'Campus Music Festival',
          'description':
              'Enjoy performances and music from talented students.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 18))),
          'venue': 'Open Grounds',
          'category': 'Entertainment',
          'attendeeCount': 120,
        },
        {
          'title': 'Community Outreach Program',
          'description':
              'Participate in community service and outreach activities.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 21))),
          'venue': 'Community Extension Center',
          'category': 'Community',
          'attendeeCount': 35,
        },
        {
          'title': 'Cybersecurity Awareness Seminar',
          'description':
              'Learn about cybersecurity, online safety, and protecting personal information.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 24))),
          'venue': 'Computer Laboratory 2',
          'category': 'Technology',
          'attendeeCount': 48,
        },
        {
          'title': 'Photography Workshop',
          'description':
              'Learn photography basics, composition, and creative techniques.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 27))),
          'venue': 'Media Arts Room',
          'category': 'Arts',
          'attendeeCount': 29,
        },
        {
          'title': 'Student Wellness Day',
          'description':
              'Participate in activities promoting student wellbeing and campus community.',
          'dateTime': Timestamp.fromDate(now.add(const Duration(days: 30))),
          'venue': 'Student Wellness Center',
          'category': 'Wellness',
          'attendeeCount': 64,
        },
      ];

      final missingEvents = events.where((event) {
        return !existingTitles.contains(event['title']);
      }).toList();

      print('SEEDER: Missing events: ${missingEvents.length}');

      if (missingEvents.isEmpty) {
        print('SEEDER: All 10 events already exist. Nothing to add.');
        return;
      }

      final batch = firestore.batch();

      for (final event in missingEvents) {
        final document = eventsCollection.doc();
        batch.set(document, event);
      }

      await batch.commit();

      print('SEEDER: SUCCESS! Added ${missingEvents.length} missing events.');
    } catch (error, stackTrace) {
      print('SEEDER ERROR: $error');
      print(stackTrace);
    }
  }
}