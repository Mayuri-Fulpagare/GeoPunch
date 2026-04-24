import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/services/location_service.dart';
import 'package:frontend/core/api/api_client.dart';

class AttendanceController extends GetxController {
  final LocationService _locationService = LocationService();
  
  var isCheckingIn = false.obs;
  var checkInTime = Rxn<DateTime>();
  var distance = 0.0.obs;

  // Ideally, this should come from a secure storage after login
  String userId = ''; 
  // You can paste the Office ID you generated from the backend here for testing
  final String testOfficeId = '5b596184-c25b-4fcf-ae3b-f9c343775573'; 

  Future<void> checkIn() async {
    try {
      isCheckingIn.value = true;
      
      // 1. Get highly accurate location using our USP feature
      Get.snackbar('Location', 'Acquiring high-accuracy GPS (Multi-sample)...');
      final position = await _locationService.getVerifiedLocation();

      Get.snackbar('Location Acquired', 'Verifying distance with Server...');
      
      // 2. Call the backend API
      final response = await ApiClient.instance.post('/attendance/check-in', data: {
        'userId': userId,
        'officeId': testOfficeId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        checkInTime.value = DateTime.now();
        distance.value = response.data['distance'] ?? 0.0;
        
        Get.snackbar(
          'Success!', 
          'Checked in successfully! You are ${distance.value.toStringAsFixed(1)}m away from the center.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } on LocationException catch (e) {
      Get.snackbar('Location Error', e.message, backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      // Dio errors (e.g. 400 Bad Request if too far away)
      String errorMsg = 'Failed to check in';
      if (e is Exception && e.toString().contains('400')) {
        errorMsg = 'You are too far from the office or already checked in.';
      }
      Get.snackbar('Error', errorMsg, backgroundColor: Colors.redAccent, colorText: Colors.white);
      print(e);
    } finally {
      isCheckingIn.value = false;
    }
  }
}
