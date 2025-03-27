import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class PDFService {
  Future<File> generateHouseholdReport(List<User> members) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Household Report', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Members:', style: pw.TextStyle(fontSize: 18)),
            ...members.map((member) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Text('${member.name} (${member.email})'),
                )),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/household_report.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
