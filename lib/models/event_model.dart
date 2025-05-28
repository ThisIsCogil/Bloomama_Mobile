class EventModel {
  final int eventId;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String status;

  EventModel({
    required this.eventId,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'],
      title: json['title'],
      description: json['description'],
      startDateTime: DateTime.parse(json['start_date_time']),
      endDateTime: DateTime.parse(json['end_date_time']),
      status: json['status'],
    );
  }
}
