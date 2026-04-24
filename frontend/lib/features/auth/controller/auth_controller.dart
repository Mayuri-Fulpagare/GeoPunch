import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/features/attendance/view/attendance_screen.dart';

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

    isLoading.value = true;
    
    // Simulate API call for now
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    // For now, if the user clicks login, we just send them to the Attendance Screen
    Get.offAll(() => const AttendanceScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
