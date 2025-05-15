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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      // password is not returned by the API for security reasons
      phoneNumber: json['phone_number'],
      address: json['address'],
      profilePicture: json['profile_picture'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'profile_picture': profilePicture,
      'token': token,
    };

    // Include password only if it's not null
    if (password != null) {
      data['password'] = password;
    }

    return data;
  }
}
