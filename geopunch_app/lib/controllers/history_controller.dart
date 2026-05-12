import 'package:get/get.dart';
import 'package:frontend/services/api_client.dart';
import 'package:frontend/models/attendance_history_model.dart';
import 'package:flutter/material.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var historyResponse = Rxn<AttendanceHistoryResponse>();

  // Use the same mock userId or fetch it from storage
  String userId = 'mock-user-id'; 

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    fetchHistory(now.month, now.year);
  }

  Future<void> fetchHistory(int month, int year) async {
    try {
      isLoading.value = true;
      final response = await ApiClient.instance.get(
        '/attendance/history/$userId',
        queryParameters: {
          'month': month,
          'year': year,
        },
      );

      if (response.statusCode == 200) {
        historyResponse.value = AttendanceHistoryResponse.fromJson(response.data);
      }
    } catch (e) {
      // Create a dummy response for UI testing if backend is failing/empty
      debugPrint('Error fetching history: $e');
      historyResponse.value = AttendanceHistoryResponse(
        month: month,
        year: year,
        summary: Summary(totalPresent: 0, totalWorkingHours: 0),
        data: [],
      );
    } finally {
      isLoading.value = false;
    }
  }

  AttendanceRecord? getRecordForDate(DateTime date) {
    if (historyResponse.value == null) return null;
    try {
      return historyResponse.value!.data.firstWhere((record) {
        return record.checkInTime.year == date.year &&
               record.checkInTime.month == date.month &&
               record.checkInTime.day == date.day;
      });
    } catch (e) {
      return null; // Not found
    }
  }
}
