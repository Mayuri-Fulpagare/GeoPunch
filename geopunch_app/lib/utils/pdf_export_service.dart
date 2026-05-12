import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/attendance_history_model.dart';

class PdfExportService {
  static Future<void> exportMonthlyHistory(AttendanceHistoryResponse history) async {
    final pdf = pw.Document();

    final monthName = DateFormat('MMMM yyyy').format(DateTime(history.year, history.month));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(monthName),
            pw.SizedBox(height: 20),
            _buildSummaryBox(history.summary),
            pw.SizedBox(height: 20),
            _buildAttendanceTable(history.data),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Attendance_Report_$monthName.pdf',
    );
  }

  static pw.Widget _buildHeader(String monthName) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('GeoPunch', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
            pw.SizedBox(height: 4),
            pw.Text('Monthly Attendance Report', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
          ],
        ),
        pw.Text(monthName, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildSummaryBox(Summary summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Total Present', '${summary.totalPresent} Days'),
          _summaryItem('Total Hours', '${summary.totalWorkingHours} hrs'),
        ],
      ),
    );
  }

  static pw.Widget _summaryItem(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildAttendanceTable(List<AttendanceRecord> records) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Punch In', 'Punch Out', 'Status', 'Hours'],
      data: records.map((record) {
        return [
          DateFormat('dd MMM yyyy').format(record.checkInTime),
          DateFormat('hh:mm a').format(record.checkInTime),
          record.checkOutTime != null ? DateFormat('hh:mm a').format(record.checkOutTime!) : '--',
          record.status,
          record.workingHours != null ? record.workingHours!.toStringAsFixed(1) : '--',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.green700),
      rowDecoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300))),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.all(8),
    );
  }
}
