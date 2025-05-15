import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../views/navbar.dart';
import '../views/auth_screen.dart'; // Import halaman auth

class AuthController {
  Future<void> login(String email, String password, BuildContext context) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw "Email dan password harus diisi";
      }

      // Show loading indicator with Lottie animation
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

        // Close loading dialog
        Navigator.pop(context);

        // Show success snackbar
        _showSuccessSnackBar(context, 'Login berhasil!');

        // Navigate to main screen
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
      _showErrorSnackBar(context, e.toString());
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

      // Show loading indicator with Lottie animation
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

      // Make API call
      final response = await ApiService.register(user, confirmPassword);

      if (response['status'] == true || response['token'] != null) {
        // Close loading indicator first
        Navigator.pop(context);
        
        // Show success snackbar
        _showSuccessSnackBar(context, 'Registrasi berhasil!');

        // Wait a moment before proceeding
        await Future.delayed(const Duration(milliseconds: 1500));

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
      _showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    bool confirmLogout = false;

    // Tampilkan dialog konfirmasi logout
    await AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: 'Konfirmasi Logout',
      desc: 'Apakah Anda yakin ingin logout?',
      btnCancelOnPress: () {},
      btnCancelText: 'Batal',
      btnCancelColor: Colors.grey,
      btnOkOnPress: () {
        confirmLogout = true;
      },
      btnOkText: 'Logout',
      btnOkColor: Colors.red,
      headerAnimationLoop: false,
    ).show();

    if (!confirmLogout) return;

    try {
      // Tampilkan loading animation
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

      try {
        // Coba lakukan api logout
        await ApiService.logout();
      } catch (e) {
        // Jika terjadi error pada API, abaikan dan lanjutkan dengan logout lokal
        print("API logout error: $e");
        // Error tidak perlu dilempar kembali, kita tetap lanjutkan proses logout lokal
      }
      
      // Hapus token dan data user lokal (ini harus selalu berhasil)
      await ApiService.clearToken();

      // Tutup loading dialog
      Navigator.pop(context);

      // Tampilkan dialog sukses logout
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.bottomSlide,
        title: 'Logout Berhasil',
        desc: 'Anda telah berhasil logout dari akun Anda',
        btnOkOnPress: () {
          // Navigasi ke halaman login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
            (route) => false,
          );
        },
        btnOkText: 'OK',
        btnOkColor: Colors.green,
        headerAnimationLoop: false,
      ).show();
    } catch (e) {
      Navigator.pop(context); // Pastikan loading dialog ditutup meski error

      // Tampilkan dialog error yang lebih user-friendly
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Logout Gagal',
        desc: 'Terjadi kesalahan saat proses logout. Silakan coba lagi.',
        btnOkOnPress: () {},
        btnOkText: 'Mengerti',
        btnOkColor: Colors.red,
        headerAnimationLoop: false,
      ).show();
    }
  }


  // Helper method to show success snackbar
  void _showSuccessSnackBar(BuildContext context, String message) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.success,
      duration: const Duration(seconds: 2),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomRight,
    ).show(context);
  }

  // Helper method to show error snackbar
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