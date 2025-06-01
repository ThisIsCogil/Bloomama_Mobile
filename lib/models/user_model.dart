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

  // PERBAIKAN: fromJson untuk API responses dan SharedPreferences
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] is int 
          ? json['user_id'] 
          : int.tryParse(json['user_id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      address: json['address'],
      profilePicture: json['profile_picture'],
      profilePictureUrl: json['profile_picture_url'], // PENTING: pastikan ini ada
      token: json['token'],
    );
  }

  // PERBAIKAN: toJson untuk API requests dan SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'name': name,
      'email': email,
      if (password != null) 'password': password,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl, // PENTING
      if (token != null) 'token': token,
    };
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

  // PERBAIKAN: Method untuk mendapatkan URL gambar profil
  String? getProfileImageUrl() {
    // Debug print untuk troubleshooting
    print('Getting profile image URL...');
    print('profilePictureUrl: $profilePictureUrl');
    print('profilePicture: $profilePicture');
    
    // Prioritas 1: Gunakan profile_picture_url jika ada (sudah full URL)
    if (profilePictureUrl != null && profilePictureUrl!.isNotEmpty) {
      print('Using profilePictureUrl: $profilePictureUrl');
      return profilePictureUrl;
    } 
    
    // Prioritas 2: Konstruksi URL dari profile_picture path
    if (profilePicture != null && profilePicture!.isNotEmpty) {
      const String baseUrl = 'http://192.168.91.233:8000'; // Sesuaikan dengan base URL Anda
      final String constructedUrl = '$baseUrl/storage/$profilePicture';
      print('Constructed URL: $constructedUrl');
      return constructedUrl;
    }
    
    print('No profile image available');
    return null;
  }

  // Method untuk cek apakah user memiliki foto profil
  bool hasProfileImage() {
    return getProfileImageUrl() != null;
  }

  @override
  String toString() {
    return 'User(userId: $userId, name: $name, email: $email, profilePictureUrl: $profilePictureUrl)';
  }
}