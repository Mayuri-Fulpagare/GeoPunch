import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/features/attendance/view/attendance_screen.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/attendance/controller/attendance_controller.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isLoading = false.obs;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await ApiClient.instance.post('/auth/login', data: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        final token = response.data['access_token'];
        final userId = response.data['user']['id'];

        // Store token in API Client for future requests
        ApiClient.setToken(token);

        // Pre-initialize Attendance Controller and inject User ID
        final attendanceCtrl = Get.put(AttendanceController());
        attendanceCtrl.userId = userId;

        // Navigate to Dashboard
        Get.offAll(() => const AttendanceScreen());
      }
    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid credentials or server error', 
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
