class HealthData {
  final int trackingId;
  final int userId;
  final int? pregnancyId; // Made nullable
  final double weight;
  final String bloodPressure;
  final int heartRate;
  final double height;
  final DateTime dateRecorded;
  final int? pregnancyweek; // Made nullable
  final String notes;

  HealthData({
    required this.trackingId,
    required this.userId,
    this.pregnancyId, // Now optional
    required this.weight,
    required this.bloodPressure,
    required this.heartRate,
    required this.height,
    required this.dateRecorded,
    this.pregnancyweek, // Now optional
    required this.notes,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      trackingId: json['tracking_id'] ?? json['id'],
      userId: json['user_id'],
      pregnancyId: json['pregnancy_id'], // Can be null
      weight: _toDouble(json['weight']),
      bloodPressure: json['blood_pressure'] ?? '',
      heartRate: json['heart_rate'] ?? 0,
      height: _toDouble(json['height']),
      dateRecorded: DateTime.parse(json['date_recorded']),
      pregnancyweek: json['week'], // API returns 'week' field
      notes: json['notes'] ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper to extract systolic blood pressure (first number in "120/80" format)
  double get systolicBloodPressure {
    if (bloodPressure.contains('/')) {
      return double.tryParse(bloodPressure.split('/')[0]) ?? 0;
    }
    return double.tryParse(bloodPressure) ?? 0;
  }
}