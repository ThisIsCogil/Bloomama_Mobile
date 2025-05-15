import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Save auth token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// Save and retrieve user object locally
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  /// Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      final user = User.fromJson(data);
      await saveUser(user);
      await saveToken(user.token!);
    }
    return data;
  }

  /// Register
  static Future<Map<String, dynamic>> register(User user, String confirmPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'password_confirmation': confirmPassword,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      final newUser = User.fromJson(data);
      await saveUser(newUser);
      await saveToken(newUser.token!);
    }
    return data;
  }

  /// Logout
  static Future<Map<String, dynamic>> logout() async {
    final token = await getToken();
    
    if (token == null) {
      throw 'Token tidak ditemukan. Tidak dapat logout.';
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10)); // Tambahkan timeout

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          // Jika respons bukan JSON yang valid, anggap tetap berhasil
          // karena respons 200 atau 201
          return {'status': true, 'message': 'Logout berhasil'};
        }
      } else {
        // Jika status code tidak 200/201, kita tetap akan hapus token lokal
        // tapi juga throw exception untuk logging
        String message;
        try {
          final errorData = jsonDecode(response.body);
          message = errorData['message'] ?? 'Logout gagal. Status code: ${response.statusCode}';
        } catch (e) {
          message = 'Logout gagal. Status code: ${response.statusCode}';
        }
        throw message;
      }
    } catch (e) {
      // Jika ada error (timeout atau lainnya), kita mau tetap logout lokal
      // tapi juga throw exception untuk logging
      throw 'Logout API error: ${e.toString()}';
    }
  }

  /// Get authenticated user profile
  static Future<User?> getUserProfile() async {
    final token = await getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      await saveUser(user);
      return user;
    }
    return null;
  }
}
