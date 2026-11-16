import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AccountController extends GetxController {
  final GetStorage _storage = GetStorage();

  final Rxn<UserModel> user = Rxn<UserModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final token = _storage.read('token') ?? '';
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is! Map<String, dynamic>) {
          throw const FormatException('Format respons server tidak valid');
        }

        final data = UserModel.fromJson(body);
        user.value = data;

        await _storage.write('name', data.name);
        await _storage.write('email', data.email);
        await _storage.write('role', data.role);
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Sesi Anda telah berakhir. Silakan login kembali.';
      } else {
        errorMessage.value = 'Gagal memuat data akun (${response.statusCode}).';
      }
    } catch (e) {
      errorMessage.value = 'Server tidak dapat dihubungi.';
      debugPrint('Account error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get displayName {
    final fromUser = user.value?.name.trim() ?? '';
    if (fromUser.isNotEmpty) return fromUser;
    return _storage.read('name')?.toString() ?? 'Pengguna';
  }

  String get displayEmail {
    final fromUser = user.value?.email.trim() ?? '';
    if (fromUser.isNotEmpty) return fromUser;
    return _storage.read('email')?.toString() ?? '-';
  }
}
