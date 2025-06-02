class MidwifeModel {
  final int midwifeId;
  final String name;
  final String email;
  final String phoneNumber;
  final String status;
  final String? profilePicture;
  final String availableDay;
  final String startTime;
  final String endTime;

  MidwifeModel({
    required this.midwifeId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.status,
    this.profilePicture,
    required this.availableDay,
    required this.startTime,
    required this.endTime,
  });

  factory MidwifeModel.fromJson(Map<String, dynamic> json) {
    return MidwifeModel(
      midwifeId: json['midwife_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      status: json['status'] ?? '',
      profilePicture: json['profile_picture'],
      availableDay: json['available_day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'midwife_id': midwifeId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'status': status,
      'profile_picture': profilePicture,
      'available_day': availableDay,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  // Format jam operasional untuk ditampilkan
  String get operationalHours => '$startTime - $endTime';
  
  // Format nomor WhatsApp (menghilangkan karakter non-digit)
  String get formattedPhoneNumber {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Jika nomor dimulai dengan 0, ganti dengan 62
    if (cleaned.startsWith('0')) {
      cleaned = '62${cleaned.substring(1)}';
    }
    
    // Jika belum ada kode negara, tambahkan 62
    if (!cleaned.startsWith('62')) {
      cleaned = '62$cleaned';
    }
    
    return cleaned;
  }
}

class MidwifeResponse {
  final bool success;
  final String message;
  final List<MidwifeModel>? data;
  final String? error;

  MidwifeResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory MidwifeResponse.fromJson(Map<String, dynamic> json) {
    return MidwifeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => MidwifeModel.fromJson(item))
              .toList()
          : null,
      error: json['error'],
    );
  }
}