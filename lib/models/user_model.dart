import 'dart:convert';

class User {
  final int? userId;
  final String name;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;
  final String? profilePictureUrl;
  final String? token;

  User({
    this.userId,
    required this.name,
    required this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.profilePicture,
    this.profilePictureUrl,
    this.token,
  });

  // For API responses
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      address: json['address'],
      profilePicture: json['profile_picture'],
      profilePictureUrl: json['profile_picture_url'],
      token: json['token'],
    );
  }

  // For API requests
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'name': name,
      'email': email,
      if (password != null) 'password': password,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
      if (token != null) 'token': token,
    };
  }

  // For SharedPreferences storage
  String toJsonString() {
    return json.encode({
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'profile_picture': profilePicture,
      'profile_picture_url': profilePictureUrl,
      // Never store password or token in SharedPreferences
    });
  }

  // For SharedPreferences retrieval
  factory User.fromJsonString(String jsonString) {
    final data = json.decode(jsonString);
    return User(
      userId: data['user_id'] is int ? data['user_id'] : int.tryParse(data['user_id'].toString()),
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phone_number'],
      address: data['address'],
      profilePicture: data['profile_picture'],
      profilePictureUrl: data['profile_picture_url'],
      // Don't retrieve password or token from SharedPreferences
    );
  }

  // Copy with method for immutability
  User copyWith({
    int? userId,
    String? name,
    String? email,
    String? password,
    String? phoneNumber,
    String? address,
    String? profilePicture,
    String? profilePictureUrl,
    String? token,
  }) {
    return User(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profilePicture: profilePicture ?? this.profilePicture,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      token: token ?? this.token,
    );
  }

  // Get profile image URL with fallback
  String? getProfileImageUrl() {
    if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
      return profilePictureUrl;
    } else if (profilePicture != null && profilePicture!.isNotEmpty) {
      // Fallback to construct URL from profile_picture path
      return 'YOUR_LARAVEL_BASE_URL/storage/$profilePicture';
    }
    return null;
  }
}