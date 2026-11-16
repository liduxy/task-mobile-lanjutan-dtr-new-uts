import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../routes/app_routes.dart';

import '../binding/dashboard.dart';
import 'account_controller.dart';

// import '../routes/app_routes.dart';

class DashboardController extends GetxController {
  final tempstorage = GetStorage();
  final token = "".obs;
  final username = "".obs;
  final email = "".obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final totalUser = 0.obs;
  final totalRuangan = 0.obs;
  final totalBooking = 0.obs;
  final tersedia = 0.obs;

  @override
  void onInit() {
    super.onInit();
    token.value = tempstorage.read('token') ?? '';
    // Login menyimpan nama pada key 'name', sedangkan kode lama memakai
    // 'username'. Fallback ini membuat nama tetap tampil di dashboard/profile.
    username.value =
        tempstorage.read('username') ?? tempstorage.read('name') ?? '';
    email.value = tempstorage.read('email') ?? '';
    dashboard();
  }

  Future<void> dashboard() async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.value}',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
        final dashboardJson = responseBody['data'] is Map<String, dynamic>
            ? responseBody['data'] as Map<String, dynamic>
            : responseBody;
        final data = DashboardModel.fromJson(dashboardJson);

        totalUser.value = data.totalUser;
        totalRuangan.value = data.totalRuangan;
        totalBooking.value = data.totalBooking;
        tersedia.value = data.ruanganTersedia;
      } else {
        errorMessage.value =
            'Gagal memuat dashboard (${response.statusCode}). Silakan coba lagi.';
      }
    } catch (e) {
      errorMessage.value = 'Server tidak dapat dihubungi.';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await tempstorage.erase();
    Get.offAllNamed(AppRoutes.login);

    // Hapus controller agar data pengguna lama tidak terbawa setelah login
    // kembali dengan akun lain.
    if (Get.isRegistered<AccountController>()) {
      Get.delete<AccountController>(force: true);
    }
    Get.delete<DashboardController>(force: true);
  }
}
