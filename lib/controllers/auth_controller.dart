import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../views/navbar.dart';

class AuthController {
  Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw "Email dan password harus diisi";
      }
      
      await Future.delayed(Duration(seconds: 1));
      
      // Navigasi langsung ke HomeScreen
      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => MainScreen()),
   );
    
    } catch (e) {
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
    if (user.password != confirmPassword) {
      throw "Password tidak cocok";
    }

    await Future.delayed(Duration(seconds: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Registrasi berhasil!")),
    );

    Navigator.pop(context); // Tutup bottom sheet register

    if (onSuccess != null) {
      onSuccess();
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
}