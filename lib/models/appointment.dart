// models/appointment.dart
class Appointment {
  final int id;
  final int userId;
  final String notes;
  final String dateTime;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? midwifeName;

  Appointment({
    required this.id,
    required this.userId,
    required this.notes,
    required this.dateTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.midwifeName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['appointment_id'] ?? 0, // Ubah dari 'id' ke 'appointment_id'
      userId: json['user_id'] ?? 0,
      notes: json['notes'] ?? '',
      dateTime: json['date_time'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      midwifeName: json['midwife_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': id, // Ubah dari 'id' ke 'appointment_id'
      'user_id': userId,
      'notes': notes,
      'date_time': dateTime,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'midwife_name': midwifeName,
    };
  }

  Appointment copyWith({
    int? id,
    int? userId,
    String? notes,
    String? dateTime,
    String? status,
    String? createdAt,
    String? updatedAt,
    String? midwifeName,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notes: notes ?? this.notes,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      midwifeName: midwifeName ?? this.midwifeName,
    );
  }
}