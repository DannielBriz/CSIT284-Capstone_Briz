
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/event.dart';
import 'auth_service.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsCollection =>
      _firestore.collection('events');

  CollectionReference<Map<String, dynamic>> get _registrationsCollection =>
      _firestore.collection('registrations');

  // =========================================================
  // READ: Get all events in real time
  // =========================================================
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
          attendeeCount: _safeCount(data['attendeeCount']),
        );
      }).toList();
    });
  }

  // =========================================================
  // HELPER: Safely read attendee count
  // =========================================================
  int _safeCount(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  // =========================================================
  // CREATE: Add an event
  // =========================================================
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

  // =========================================================
  // UPDATE: Edit an event
  // =========================================================
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

  // =========================================================
  // DELETE: Remove an event
  // =========================================================
  Future<void> deleteEvent(String eventId) async {
    await _eventsCollection.doc(eventId).delete();
  }

  // =========================================================
  // RSVP: Register for an event
  // =========================================================
  Future<void> registerForEvent(String eventId) async {
    final userId = AuthService.currentUserId;

    if (userId == null) {
      throw Exception('You are not signed in. Please restart the app.');
    }

    final registrationId = '${eventId}_$userId';

    final registrationRef =
        _registrationsCollection.doc(registrationId);

    final eventRef = _eventsCollection.doc(eventId);

    await _firestore.runTransaction<void>((transaction) async {
      // Read first, before any writes.
      final registrationSnapshot =
          await transaction.get(registrationRef);

      final eventSnapshot = await transaction.get(eventRef);

      if (!eventSnapshot.exists) {
        throw Exception('The event could not be found.');
      }

      // Already registered: don't duplicate or increment count.
      if (registrationSnapshot.exists) {
        return;
      }

      final eventData = eventSnapshot.data();
      final currentCount = _safeCount(eventData?['attendeeCount']);

      // Create the registration.
      transaction.set(registrationRef, {
        'eventId': eventId,
        'userId': userId,
        'registeredAt': FieldValue.serverTimestamp(),
      });

      // Increase attendee count.
      transaction.update(eventRef, {
        'attendeeCount': currentCount + 1,
      });
    });
  }

  // =========================================================
  // RSVP: Cancel registration
  // =========================================================
  Future<void> cancelRegistration(String eventId) async {
    final userId = AuthService.currentUserId;

    if (userId == null) {
      throw Exception('You are not signed in. Please restart the app.');
    }

    final registrationId = '${eventId}_$userId';

    final registrationRef =
        _registrationsCollection.doc(registrationId);

    final eventRef = _eventsCollection.doc(eventId);

    await _firestore.runTransaction<void>((transaction) async {
      // Read before writes.
      final registrationSnapshot =
          await transaction.get(registrationRef);

      final eventSnapshot = await transaction.get(eventRef);

      // Nothing to cancel.
      if (!registrationSnapshot.exists) {
        return;
      }

      // Delete registration.
      transaction.delete(registrationRef);

      // Decrease attendee count if the event still exists.
      if (eventSnapshot.exists) {
        final eventData = eventSnapshot.data();
        final currentCount = _safeCount(eventData?['attendeeCount']);

        transaction.update(eventRef, {
          'attendeeCount': currentCount > 0 ? currentCount - 1 : 0,
        });
      }
    });
  }

  // =========================================================
  // RSVP: Check registration status
  // =========================================================
  Future<bool> isRegisteredForEvent(String eventId) async {
    final userId = AuthService.currentUserId;

    if (userId == null) {
      return false;
    }

    final registrationId = '${eventId}_$userId';

    final snapshot =
        await _registrationsCollection.doc(registrationId).get();

    return snapshot.exists;
  }

  // =========================================================
  // RSVP: Real-time stream for My Events
  // =========================================================
  Stream<Set<String>> getRegisteredEventIds() {
    final userId = AuthService.currentUserId;

    if (userId == null) {
      return Stream.value(<String>{});
    }

    return _registrationsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['eventId'] as String)
          .toSet();
    });
  }
}
