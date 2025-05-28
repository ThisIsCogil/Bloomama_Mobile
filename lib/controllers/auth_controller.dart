  import 'package:flutter/material.dart';
  import 'package:lottie/lottie.dart';
  import 'package:animated_snack_bar/animated_snack_bar.dart';
  import 'package:awesome_dialog/awesome_dialog.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import '../models/user_model.dart';
  import '../services/api_service.dart';
  import '../views/navbar.dart';
  import '../views/auth_screen.dart';
  import 'dart:convert';

  class AuthController {
    static const String _userKey = 'user_data';
    static const String _tokenKey = 'auth_token';

    Future<void> saveUser(User user) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
    }

    Future<User?> getUser() async {
      final prefs = await SharedPreferences.getInstance();
      final userJsonString = prefs.getString(_userKey);
      if (userJsonString != null) {
        try {
          final userJson = json.decode(userJsonString) as Map<String, dynamic>;
          return User.fromJson(userJson);
        } catch (e) {
          print('Error parsing user data: $e');
          return null;
        }
      }
      return null;
    }

    Future<void> clearUser() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_tokenKey);
    }

    Future<void> saveToken(String token) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    }

    Future<String?> getToken() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    }

    Future<void> login(
        String email, String password, BuildContext context) async {
      try {
        if (email.isEmpty || password.isEmpty) {
          throw "Email dan password harus diisi";
        }

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

        final response = await ApiService.login(email, password);
        final data = response['data'];

        if (data != null && data['token'] != null && data['user'] != null) {
          final userJson = data['user'] as Map<String, dynamic>;
          final token = data['token'] as String;

          final user = User.fromJson(userJson).copyWith(token: token);

          await saveUser(user);
          await saveToken(token);

          Navigator.pop(context); // Close loading
          _showSuccessSnackBar(context, 'Login berhasil!');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false,
          );
        } else {
          throw response['message'] ?? "Login gagal";
        }
      } catch (e) {
        Navigator.pop(context); // Close loading
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
        if (user.name.isEmpty ||
            user.email.isEmpty ||
            user.password == null ||
            user.password!.isEmpty) {
          throw "Semua field harus diisi";
        }

        if (user.password != confirmPassword) {
          throw "Password tidak cocok";
        }

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

        final response = await ApiService.register(user, confirmPassword);

        if (response['status'] == true || response['token'] != null) {
          Navigator.pop(context);
          _showSuccessSnackBar(context, 'Registrasi berhasil!');

          await Future.delayed(const Duration(milliseconds: 1500));

          if (onSuccess != null) {
            onSuccess();
          } else {
            Navigator.pop(context);
          }
        } else {
          throw response['message'] ?? "Registrasi gagal";
        }
      } catch (e) {
        Navigator.pop(context);
        _showErrorSnackBar(context, e.toString());
      }
    }

    Future<void> updateProfile({
      required BuildContext context,
      String? name,
      String? phoneNumber,
      String? address,
      String? profilePicture,
      VoidCallback? onSuccess,
    }) async {
      try {
        // Cek token terlebih dahulu
        final token = await getToken();
        if (token == null) {
          throw 'Anda harus login terlebih dahulu';
        }
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

        // Call API to update profile
        final response = await ApiService.updateProfile(
          name: name,
          phoneNumber: phoneNumber,
          address: address,
          profilePicture: profilePicture,
        );

        // Close loading dialog
        Navigator.pop(context);

        if (response['status'] == true) {
          // Update local user data
          final updatedUser = response['user'] as User;
          await saveUser(updatedUser);

          _showSuccessSnackBar(context, 'Profil berhasil diperbarui');

          // Call success callback if provided
          if (onSuccess != null) {
            onSuccess();
          }
        } else {
          throw response['message'] ?? 'Gagal memperbarui profil';
        }
      } catch (e) {
        Navigator.pop(context); // Close loading dialog in case of error
        _showErrorSnackBar(context, e.toString());
      }
    }

    Future<void> changePassword({
      required BuildContext context,
      required String currentPassword,
      required String newPassword,
      required String confirmPassword,
    }) async {
      try {
        final token = await getToken();
        if (token == null) {
          throw 'Anda harus login terlebih dahulu';
        }

        if (newPassword != confirmPassword) {
          throw 'Password baru dan konfirmasi tidak cocok';
        }

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

        final response = await ApiService.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        );

        Navigator.pop(context); // Close loading

        if (response['status'] == true) {
          _showSuccessSnackBar(
              context, response['message'] ?? 'Password berhasil diubah');

          // Kembali ke halaman sebelumnya
          await Future.delayed(
              Duration(milliseconds: 200)); // beri waktu untuk snack bar tampil
          Navigator.pop(context);
        } else {
          throw response['message'] ?? 'Gagal mengubah password';
        }
      } catch (e) {
        Navigator.pop(context); // Close loading in case of error
        _showErrorSnackBar(context, e.toString());
      }
    }

    Future<void> logout(BuildContext context) async {
      bool confirmLogout = false;

      await AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.scale,
        title: 'Konfirmasi Logout',
        desc: 'Apakah Anda yakin ingin logout?',
        btnCancelOnPress: () {},
        btnCancelText: 'Batal',
        btnCancelColor: Colors.grey,
        btnOkOnPress: () => confirmLogout = true,
        btnOkText: 'Logout',
        btnOkColor: Colors.red,
        headerAnimationLoop: false,
      ).show();

      if (!confirmLogout) return;

      try {
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
          await ApiService.logout();
        } catch (e) {
          print("API logout error: $e");
        }

        await clearUser();

        Navigator.pop(context);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: 'Logout Berhasil',
          desc: 'Anda telah berhasil logout dari akun Anda',
          btnOkOnPress: () {
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
        Navigator.pop(context);
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
