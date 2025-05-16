import 'dart:convert';

class User {
  final int? userId;
  final String name;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String? address;
  final String? profilePicture;
  final String? token;

  User({
    this.userId,
    required this.name,
    required this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.profilePicture,
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
      token: token ?? this.token,
    );
  }
}