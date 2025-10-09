import '../models/health_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class KesehatanController {
  final ApiService apiService;

  KesehatanController({required this.apiService});

  Future<HealthData?> getHealthTrackingByWeek(int week) async {
    try {
      final user = await AuthController().getUser();
      if (user == null || user.userId == null) return null;

      final response = await ApiService.getHealthTrackingByWeek(user.userId!, week);

      print('API response (getHealthTrackingByWeek): $response');

      if (response['success'] == true && response['data'] != null) {
        return HealthData.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('Error getting health data for week $week: $e');
      return null;
    }
  }
}
