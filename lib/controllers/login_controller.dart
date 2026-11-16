import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final tmp = GetStorage();
  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  final isLoading = false.obs;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login() async {
    if (isLoading.value) return;

    // Validasi sebelum loading dimulai
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Login Gagal',
        'Email dan password wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Login Gagal',
        'Format email tidak valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (responseBody is! Map<String, dynamic>) {
        throw Exception('Format respons server tidak valid');
      }

      if (response.statusCode == 200) {
        // Ambil token dari Laravel
        final token = responseBody['access_token'];
        final user = responseBody['user'];

        if (token == null || user is! Map<String, dynamic>) {
          throw Exception('Token atau data pengguna tidak ditemukan');
        }

        // Simpan token dan informasi pengguna
        await tmp.write('token', token);
        await tmp.write('name', user['name']);
        await tmp.write('email', user['email']);

        Get.snackbar(
          'Login Berhasil',
          'Selamat datang! ${user['name']}',
          backgroundColor: const Color.fromARGB(255, 54, 244, 92),
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoutes.main);
      } else {
        Get.snackbar(
          'Login Gagal',
          responseBody['message']?.toString() ?? 'Email atau password salah.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghubungi server. Periksa koneksi dan API.',
        snackPosition: SnackPosition.BOTTOM,
      );

      debugPrint('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// class LoginController
