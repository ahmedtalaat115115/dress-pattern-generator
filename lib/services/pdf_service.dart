import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/pattern.dart';

class PdfService {
  Future<void> generatePatternPdf(Pattern pattern) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'باترون ${pattern.name}',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'معلومات الباترون',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('المقياس'),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('القيمة'),
                        ),
                      ],
                    ),
                    ...pattern.measurements.values.entries.map((entry) {
                      final label = MeasurementNames[entry.key] ?? entry.key;
                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(label),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('${entry.value} سم'),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'تعليمات الطباعة والاستخدام',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '1. اطبع على ورق حجم A4\n'
                  '2. تأكد من إعدادات الطباعة بدون هوامش\n'
                  '3. استخدم مقص حاد للقص\n'
                  '4. اتبع خطوط القطع بدقة',
                  style: const pw.TextStyle(fontSize: 12),
                  textAlign: pw.TextAlign.right,
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'تاريخ الإنشاء: ${pattern.createdAt.toString().split(' ')[0]}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );

    // حفظ الملف
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${pattern.name}_pattern.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}

const Map<String, String> MeasurementNames = {
  'height': 'الطول الكلي',
  'chestCircumference': 'محيط الصدر',
  'waistCircumference': 'محيط الخصر',
  'hipCircumference': 'محيط الأرداف',
  'shoulderWidth': 'عرض الكتفين',
  'armLength': 'طول الذراع',
  'neckCircumference': 'محيط الرقبة',
  'chestDepth': 'عمق الصدر',
  'backWidth': 'عرض الظهر',
  'sleeveLength': 'طول الكم',
};
