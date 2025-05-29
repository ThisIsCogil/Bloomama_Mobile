// controllers/appointment_controller.dart
import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../services/api_service.dart';
import '../controllers/auth_controller.dart';

class AppointmentController extends ChangeNotifier {
  final AuthController _authController = AuthController();
  
  List<Appointment> _appointments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAppointments() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      // Ambil user dari AuthController
      final user = await _authController.getUser();
      if (user == null) {
        _errorMessage = 'User tidak ditemukan. Silakan login kembali.';
        return;
      }

      // Ambil appointments berdasarkan user_id
      _appointments = await ApiService.getAppointmentsByUser(user.userId!);
      
      // Urutkan berdasarkan tanggal terbaru
      _appointments.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      
    } catch (e) {
      _errorMessage = e.toString();
      _appointments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAppointments() async {
    await fetchAppointments();
  }
}