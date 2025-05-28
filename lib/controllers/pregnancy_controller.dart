import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import '../models/health_model.dart';
import '../models/user_pregnancy.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class PregnancyController {
  final ApiService apiService;

  PregnancyController({required this.apiService});

  Future<void> registerPregnancy({
    required BuildContext context,
    required String fullName,
    required int gravida,
    required int para,
    required int abortus,
    required DateTime startDate,
    required Function(PregnancyData) onSuccess,
  }) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),
        ),
      );

      // Get current user
      final user = await AuthController().getUser();
      if (user == null || user.userId == null) {
        throw 'User session not found. Please login again.';
      }

      // Create pregnancy data
      final pregnancyData = PregnancyData.calculate(
        fullName: fullName,
        gravida: gravida,
        para: para,
        abortus: abortus,
        startDate: startDate,
      );

      // Call the API
      final response = await ApiService.registerPregnancy(
        userId: user.userId!,
        pregnancyData: pregnancyData,
      );

      // Close loading dialog
      Navigator.pop(context);

      if (response['status'] == true) {
        _showSuccessSnackBar(
            context, response['message'] ?? 'Pregnancy registered successfully');
        
        // Call the success callback with the pregnancy data
        onSuccess(pregnancyData);
      } else {
        throw response['message'] ?? 'Failed to register pregnancy';
      }
    } catch (e) {
      // Close loading dialog in case of error
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      _showErrorSnackBar(context, e.toString());
    }
  }


  Future<HealthData?> getLatestHealthTracking() async {
  try {
    final user = await AuthController().getUser();
    if (user == null || user.userId == null) return null;

    final response = await ApiService.getLatestHealthTracking(user.userId!);

    print('API response (getLatestHealthTracking): $response');

    if (response['success'] == true && response['data'] != null) {
      return HealthData.fromJson(response['data']);
    }
    return null;
  } catch (e) {
    print('Error getting latest health data: $e');
    return null;
  }
}

Future<List<HealthData>> fetchHealthTrackingData(int? userId) async {
  if (userId == null) return [];
  
  try {
    final response = await ApiService.getHealthTrackingForChart(userId);
    
    if (response['success'] == true) {
      final List<dynamic> data = response['data'];
      
      return data.map((item) => HealthData.fromJson(item)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to load data');
    }
  } catch (e) {
    throw Exception('Gagal Mengambil Data: $e');
  }
}

  // =============== Shared Utility Methods ===============
  

  void _showSuccessSnackBar(BuildContext context, String message) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.success,
      duration: const Duration(seconds: 2),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomRight,
    ).show(context);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      duration: const Duration(seconds: 3),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomRight,
    ).show(context);
  }

}