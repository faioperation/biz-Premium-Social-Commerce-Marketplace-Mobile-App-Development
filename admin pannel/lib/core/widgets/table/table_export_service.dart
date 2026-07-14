import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' hide Column, Row;
import 'package:universal_html/html.dart' as html;

class TableExportService {
  static Future<void> exportToExcel(GlobalKey<SfDataGridState> key, String fileName) async {
    if (key.currentState == null) return;
    final Workbook workbook = key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    _downloadFile(bytes, '$fileName.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
  }

  static Future<void> exportToPdf(GlobalKey<SfDataGridState> key, String fileName) async {
    if (key.currentState == null) return;
    final PdfDocument document = key.currentState!.exportToPdfDocument();
    final List<int> bytes = document.saveSync();
    document.dispose();
    _downloadFile(bytes, '$fileName.pdf', 'application/pdf');
  }

  static Future<void> exportToCsv(GlobalKey<SfDataGridState> key, String fileName) async {
    if (key.currentState == null) return;
    final StringBuffer csv = StringBuffer();
    final columns = key.currentState!.widget.columns;
    
    // Add Headers
    csv.writeln(columns.map((c) => c.columnName).join(','));
    
    // Extract rows natively from DataGridSource
    final rows = key.currentState!.widget.source.effectiveRows;
    for (var row in rows) {
      csv.writeln(row.getCells().map((cell) => cell.value.toString().replaceAll(',', ' ')).join(','));
    }
    
    _downloadFile(utf8.encode(csv.toString()), '$fileName.csv', 'text/csv');
  }

  static void _downloadFile(List<int> bytes, String fileName, String mimeType) {
    if (kIsWeb) {
      html.AnchorElement(href: "data:$mimeType;charset=utf-8;base64,${base64.encode(bytes)}")
        ..setAttribute("download", fileName)
        ..click();
    } else {
      // For Desktop/Mobile we would use path_provider and dart:io
      // This is primarily built for the web admin dashboard per requirements.
    }
  }
}
