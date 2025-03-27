import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:stockorra/models/user_model.dart';
import 'package:stockorra/models/shopping_item.dart';
import 'package:intl/intl.dart';

class ReportService {
  // Generate shopping list report
  static Future<String> generateShoppingListReport(
      List<ShoppingItem> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Shopping List Report',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
              'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Item Name', 'Quantity', 'Status'],
            data: items
                .map((item) => [
                      item.name,
                      item.quantity.toString(),
                      item.purchased ? 'Purchased' : 'Pending'
                    ])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            cellStyle: const pw.TextStyle(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Summary:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Total Items: ${items.length}'),
          pw.Text(
              'Purchased Items: ${items.where((item) => item.purchased).length}'),
          pw.Text(
              'Pending Items: ${items.where((item) => !item.purchased).length}'),
        ],
      ),
    );

    return await _saveReport(pdf, 'shopping_list_report');
  }

  // Generate household members report
  static Future<String> generateHouseholdReport(List<User> members) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Household Members Report',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
              'Generated on: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Name', 'Email', 'Role'],
            data: members
                .map((member) =>
                    [member.name, member.email, member.roles.join(', ')])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            cellAlignment: pw.Alignment.center,
            cellStyle: const pw.TextStyle(),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Summary:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text('Total Members: ${members.length}'),
          pw.Text(
              'Owners: ${members.where((m) => m.roles.contains("owner")).length}'),
          pw.Text(
              'Household Members: ${members.where((m) => m.roles.contains("household_member")).length}'),
        ],
      ),
    );

    return await _saveReport(pdf, 'household_members_report');
  }

  // Helper method to save the PDF file
  static Future<String> _saveReport(pw.Document pdf, String fileName) async {
    final output = await getApplicationDocumentsDirectory();
    final file = File(
        '${output.path}/${fileName}_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
