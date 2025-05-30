import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/pregnancy_controller.dart';
import '../models/health_model.dart';
import '../models/user_pregnancy.dart';
import '../models/content_model.dart';
import '../models/event_model.dart';
import '../models/appointment.dart';
import 'package:flutter/foundation.dart'; // Add this import

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
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          return jsonDecode(response.body);
        } catch (e) {
          return {'status': true, 'message': 'Logout berhasil'};
        }
      } else {
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
      throw 'Logout API error: ${e.toString()}';
    }
  }

  /// Get authenticated user profile
  static Future<User?> getUserProfile() async {
    final token = await AuthController().getToken();
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

  /// Update user profile
static Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phoneNumber,
    String? address,
    File? profileImageFile,
  }) async {
    final token = await AuthController().getToken();
    if (token == null) {
      throw 'Token tidak ditemukan. Silakan login kembani.';
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update-profile'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add text fields
      if (name != null) request.fields['name'] = name;
      if (phoneNumber != null) request.fields['phone_number'] = phoneNumber;
      if (address != null) request.fields['address'] = address;
      
      // Add method spoofing for PUT request
      request.fields['_method'] = 'PUT';

      // Add profile image if provided
      if (profileImageFile != null) {
        var profilePicture = await http.MultipartFile.fromPath(
          'profile_picture',
          profileImageFile.path,
        );
        request.files.add(profilePicture);
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final updatedUser = User.fromJson(data['data']['user']);
        await AuthController().saveUser(updatedUser);
        return {
          'status': true,
          'message': data['message'] ?? 'Profil berhasil diperbarui',
          'user': updatedUser,
        };
      } else {
        throw data['message'] ?? 'Gagal memperbarui profil';
      }
    } catch (e) {
      throw 'Error: $e';
    }
  }

static Future<Map<String, dynamic>> changePassword({
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  final token = await AuthController().getToken();
  if (token == null) throw 'Token tidak ditemukan. Silakan login ulang.';

  final response = await http.post(
    Uri.parse('$baseUrl/change-password'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    }),
  );

  final data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return {'status': true, 'message': data['message'] ?? 'Kata sandi berhasil diubah'};
  } else {
    throw data['message'] ?? 'Gagal mengubah kata sandi';
  }
}

static Future<Map<String, dynamic>> registerPregnancy({
  required int userId,
  required PregnancyData pregnancyData,
}) async {
  final token = await AuthController().getToken();
  if (token == null) {
    throw 'Token not found. Please login again.';
  }

  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register-pregnancies/$userId'), // Matches your Laravel route
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(pregnancyData.toApiJson()),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {
        'status': true,
        'message': responseData['message'] ?? 'Pregnancy registered successfully',
        'data': responseData['data'],
      };
    } else {
      throw responseData['message'] ?? 'Failed to register pregnancy';
    }
  } catch (e) {
    throw 'Failed to connect to server: ${e.toString()}';
  }
}

static Future<List<EventModel>> fetchEventsByDate(DateTime date) async {
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final response = await http.get(Uri.parse('$baseUrl/events?date=$formattedDate'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

static Future<PregnancyData?> getPregnancyData(int userId) async {
  final token = await AuthController().getToken();
  if (token == null) throw 'Token tidak ditemukan. Silakan login ulang.';

  try {
    final url = '$baseUrl/getPregnancyData/$userId';
    debugPrint('Making API call to: $url');
    debugPrint('Using token: ${token.substring(0, 10)}...'); // Print first 10 chars of token
    
    // Menggunakan userId sebagai parameter di URL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Debug: Print response details
    debugPrint('API Response Status: ${response.statusCode}');
    debugPrint('API Response Headers: ${response.headers}');
    debugPrint('API Response Body: ${response.body}');

    if (response.body.isEmpty) {
      debugPrint('Response body is empty');
      return null;
    }

    final data = jsonDecode(response.body);
    debugPrint('Parsed JSON Data: $data');

    if (response.statusCode == 200) {
      if (data['success'] == true && data['data'] != null) {
        debugPrint('Creating PregnancyData from JSON...');
        debugPrint('Data to parse: ${data['data']}');
        
        try {
          final pregnancyData = PregnancyData.fromApiJson(data['data']);
          debugPrint('PregnancyData created successfully: ${pregnancyData.pregnancyId}');
          return pregnancyData;
        } catch (parseError) {
          debugPrint('Error parsing PregnancyData: $parseError');
          throw 'Error parsing pregnancy data: $parseError';
        }
      } else {
        debugPrint('API returned success=false or null data');
        debugPrint('Success value: ${data['success']}');
        debugPrint('Data value: ${data['data']}');
        debugPrint('Message: ${data['message']}');
        return null;
      }
    } else if (response.statusCode == 404) {
      debugPrint('API returned 404 - Data not found');
      return null; // Data kehamilan tidak ditemukan
    } else {
      debugPrint('API returned error status: ${response.statusCode}');
      throw data['message'] ?? 'Gagal mengambil data kehamilan (Status: ${response.statusCode})';
    }
  } catch (e) {
    debugPrint('Exception in getPregnancyData: $e');
    debugPrint('Exception type: ${e.runtimeType}');
    
    rethrow; // Re-throw the original exception
  }
}


static Future<Map<String, dynamic>> getLatestHealthTracking(int userId) async {
  final token = await AuthController().getToken();
  if (token == null) throw 'Token tidak ditemukan. Silakan login ulang.';

  final response = await http.get(
    Uri.parse('$baseUrl/health-trackings/latest/$userId'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      
    },
  );

  final data = jsonDecode(response.body);
  return data;
}

static Future<Map<String, dynamic>> getHealthTrackingByWeek(int userId, int week) async {
  final token = await AuthController().getToken();
  if (token == null) throw 'Token tidak ditemukan. Silakan login ulang.';

  final response = await http.get(
    Uri.parse('$baseUrl/health-trackings/week/$userId/$week'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  final data = jsonDecode(response.body);
  return data;
  }

  // Add this to your ApiService class
static Future<Map<String, dynamic>> getHealthTrackingForChart(int userId) async {
  final token = await AuthController().getToken();
  if (token == null) throw 'Token not found. Please login again.';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/getHealthTrackingForChart/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseData;
    } else {
      throw responseData['message'] ?? 'Gagal mengambil tracking data';
    }
  } catch (e) {
    throw 'Gagal menyambung ke server: ${e.toString()}';
  }
}

  Future<List<dynamic>> getLatestContent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/latest'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load content');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> getOneContent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/one'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load content');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<dynamic>> getAllContent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/all'));
      print('API Response: ${response.body}');  // Add this line
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load content');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Content>> getContentByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/category/$category'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          List<dynamic> contentList = jsonData['data'];
          return contentList.map((json) => Content.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load content');
        }
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching content: $e');
    }
  }

  static Future<List<Appointment>> getAppointmentsByUser(int userId) async {
    try {
      final token = await AuthController().getToken();
      
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['status'] == 'success') {
          final List<dynamic> appointmentsJson = responseData['data'];
          return appointmentsJson
              .map((json) => Appointment.fromJson(json))
              .toList();
        } else {
          throw Exception('API returned error status');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Token expired atau tidak valid. Silakan login kembali.');
      } else {
        throw Exception('Failed to load appointments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<void> updateAppointmentStatus(int appointmentId, String newStatus) async {
  try {
    final token = await AuthController().getToken();
    
    final response = await http.put(
      Uri.parse('$baseUrl/appointments/$appointmentId/status'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({'status': newStatus}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['status'] != 'success') {
        throw Exception('Failed to update appointment status');
      }
    } else if (response.statusCode == 401) {
      throw Exception('Token expired or invalid. Please login again.');
    } else {
      throw Exception('Failed to update appointment: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
}