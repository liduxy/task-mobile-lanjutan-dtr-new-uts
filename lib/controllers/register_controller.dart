
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        'Registrasi Gagal',
        'Semua kolom wajib diisi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final dynamic decodedBody = jsonDecode(response.body);

      if (decodedBody is! Map<String, dynamic>) {
        Get.snackbar(
          'Error',
          'Format respons server tidak valid.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final responseBody = decodedBody;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Registrasi Berhasil',
          responseBody['message']?.toString() ??
              'Akun berhasil dibuat. Silakan login.',
          backgroundColor: const Color.fromARGB(255, 54, 244, 92),
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offNamed('/login');
      } else {
        final errors = responseBody['errors'];
        String message = responseBody['message']?.toString() ??
            'Registrasi gagal. Silakan coba kembali.';

        if (errors is Map<String, dynamic> && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          }
        }

        Get.snackbar(
          'Registrasi Gagal',
          message,
          backgroundColor: const Color.fromARGB(255, 244, 216, 54),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghubungi server. Periksa koneksi dan API.',
        snackPosition: SnackPosition.BOTTOM,
      );

      debugPrint('Register error: $e');
    }
  }

  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
