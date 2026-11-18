
class Event {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String venue;
  final String category;
  final int attendeeCount;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.venue,
    required this.category,
    this.attendeeCount = 0,
  });
}
