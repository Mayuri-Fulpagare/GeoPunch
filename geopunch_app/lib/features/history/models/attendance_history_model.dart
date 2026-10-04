class AttendanceHistoryResponse {
  final int month;
  final int year;
  final Summary summary;
  final List<AttendanceRecord> data;

  AttendanceHistoryResponse({
    required this.month,
    required this.year,
    required this.summary,
    required this.data,
  });

  factory AttendanceHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponse(
      month: json['month'] ?? 1,
      year: json['year'] ?? 2026,
      summary: Summary.fromJson(json['summary'] ?? {}),
      data: (json['data'] as List?)?.map((item) => AttendanceRecord.fromJson(item)).toList() ?? [],
    );
  }
}

class Summary {
  final int totalPresent;
  final num totalWorkingHours;

  Summary({required this.totalPresent, required this.totalWorkingHours});

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalPresent: json['totalPresent'] ?? 0,
      totalWorkingHours: json['totalWorkingHours'] ?? 0,
    );
  }
}

class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String status;
  final num? workingHours;

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.workingHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      checkInTime: DateTime.parse(json['checkInTime']).toLocal(),
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']).toLocal() : null,
      status: json['status'] ?? 'UNKNOWN',
      workingHours: json['workingHours'],
    );
  }
}
