// models/appointment.dart
class Appointment {
  final int id;
  final int userId;
  final String notes;
  final String dateTime;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.notes,
    required this.dateTime,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      notes: json['notes'] ?? '',
      dateTime: json['date_time'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'notes': notes,
      'date_time': dateTime,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}