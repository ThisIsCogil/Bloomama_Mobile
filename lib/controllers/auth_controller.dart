import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../views/navbar.dart';

class AuthController {
  Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw "Email dan password harus diisi";
      }

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Make API call
     final response = await ApiService.login(email, password);

final data = response['data'];
if (data != null && data['token'] != null && data['user'] != null) {
  final userJson = data['user'];

  final user = User(
    userId: userJson['user_id'],
    name: userJson['name'],
    email: userJson['email'],
    phoneNumber: userJson['phone_number'],
    address: userJson['address'],
    profilePicture: userJson['profile_picture'],
    token: data['token'],
  );

  await ApiService.saveUser(user);
  await ApiService.saveToken(user.token!);

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => MainScreen()),
    (route) => false,
  );
} else {
  throw response['message'] ?? "Login gagal";

      }
    } catch (e) {
      Navigator.pop(context); // Close loading in case of error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

 Future<void> register(
  User user,
  String confirmPassword,
  BuildContext context, {
  VoidCallback? onSuccess,
}) async {
  try {
    if (user.name.isEmpty || user.email.isEmpty || user.password == null || user.password!.isEmpty) {
      throw "Semua field harus diisi";
    }

    if (user.password != confirmPassword) {
      throw "Password tidak cocok";
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Make API call
    final response = await ApiService.register(user, confirmPassword);

    if (response['status'] == true || response['token'] != null) {
      // Close loading indicator first
      Navigator.pop(context);
      
      // Show success message
      await ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil!")),
      );

      // Wait for SnackBar to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Close register screen and open login
      if (onSuccess != null) {
        onSuccess();
      } else {
        Navigator.pop(context); // Close the register screen
      }
    } else {
      throw response['message'] ?? "Registrasi gagal";
    }
  } catch (e) {
    Navigator.pop(context); // Close loading in case of error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}

  Future<void> logout(BuildContext context) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await ApiService.logout();
      await ApiService.clearToken();

      // Close loading and navigate to login
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      Navigator.pop(context); // Ensure dialog is closed even on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}
