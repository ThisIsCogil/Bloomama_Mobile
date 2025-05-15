import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthMiddleware {
  static Future<bool> isAuthenticated() async {
    final token = await ApiService.getToken();
    return token != null && token.isNotEmpty;
  }

  // Use this to check if user is logged in and redirect if not
  static Future<void> checkAuth(BuildContext context) async {
    final isLoggedIn = await isAuthenticated();
    
    if (!isLoggedIn) {
      // Navigate to login screen if not authenticated
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }
}