
class Event {
  final String id;
  final String title;
  final String description;
  final String venue;
  final DateTime date;
  final String time;
  final int attendeeCount;
  final String category;
  final String imageUrl;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.date,
    required this.time,
    required this.attendeeCount,
    required this.category,
    required this.imageUrl,
  });
}
