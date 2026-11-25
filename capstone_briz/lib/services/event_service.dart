import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection {
    return _firestore.collection('events');
  }

  // READ: Get all events in real time
  Stream<List<Event>> getEvents() {
    return _eventsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return Event(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          dateTime: (data['dateTime'] as Timestamp).toDate(),
          venue: data['venue'] ?? '',
          category: data['category'] ?? '',
          attendeeCount: data['attendeeCount'] ?? 0,
        );
      }).toList();
    });
  }

  // CREATE: Add an event
  Future<void> addEvent(Event event) async {
    await _eventsCollection.add({
      'title': event.title,
      'description': event.description,
      'dateTime': Timestamp.fromDate(event.dateTime),
      'venue': event.venue,
      'category': event.category,
      'attendeeCount': event.attendeeCount,
    });
  }

  // UPDATE: Edit an existing event
  Future<void> updateEvent(Event event) async {
    await _eventsCollection.doc(event.id).update({
      'title': event.title,
      'description': event.description,
      'dateTime': Timestamp.fromDate(event.dateTime),
      'venue': event.venue,
      'category': event.category,
      'attendeeCount': event.attendeeCount,
    });
  }

  // DELETE: Remove an event
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }
}