import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/pattern.dart';
import '../services/pdf_service.dart';
import 'fabric_calculator_screen.dart';

class PatternDisplayScreen extends StatefulWidget {
  final Pattern pattern;

  const PatternDisplayScreen({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  State<PatternDisplayScreen> createState() => _PatternDisplayScreenState();
}

class _PatternDisplayScreenState extends State<PatternDisplayScreen> {
  final PdfService _pdfService = PdfService();

  Future<void> _exportToPdf() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('جاري تحضير الملف...')),
      );

      await _pdfService.generatePatternPdf(widget.pattern);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الملف بنجاح'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  void _openFabricCalculator() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FabricCalculatorScreen(
          pattern: widget.pattern,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pattern.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // رسم الباترون
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 400,
                  child: CustomPaint(
                    painter: PatternPainter(
                      pattern: widget.pattern,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // معلومات الباترون
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'معلومات الباترون',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('الاسم', widget.pattern.name),
                    _buildInfoRow('النوع', 'فستان'),
                    _buildInfoRow(
                      'تاريخ الإنشاء',
                      widget.pattern.createdAt.toString().split(' ')[0],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // المقاسات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'المقاسات',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ...widget.pattern.measurements.values.entries.map((entry) {
                      final label = Measurements.measurementNames[entry.key] ?? entry.key;
                      return _buildMeasurementRow(label, '${entry.value} سم');
                    }).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // أزرار الإجراء
            ElevatedButton.icon(
              onPressed: _exportToPdf,
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('تصدير PDF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _openFabricCalculator,
              icon: const Icon(Icons.fabric),
              label: const Text('حساب الخامة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Pattern pattern;

  PatternPainter({required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // رسم الباترون الأساسي (مثال بسيط)
    final measurements = pattern.measurements.values;
    final scale = size.width / (measurements['chestCircumference'] ?? 100);

    // الجسم الرئيسي
    final bodyPath = Path();
    bodyPath.moveTo(size.width / 2 - 20, 20);
    bodyPath.lineTo(size.width / 2 + 20, 20);
    bodyPath.lineTo(size.width / 2 + 30, 80);
    bodyPath.lineTo(size.width / 2 + 20, 200);
    bodyPath.lineTo(size.width / 2 - 20, 200);
    bodyPath.lineTo(size.width / 2 - 30, 80);
    bodyPath.close();

    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(bodyPath, strokePaint);

    // رسم الذراعين
    canvas.drawCircle(Offset(size.width / 2 - 35, 60), 10, paint);
    canvas.drawCircle(Offset(size.width / 2 + 35, 60), 10, paint);

    // رسم المعلومات
    final textPainter = TextPainter(
      text: TextSpan(
        text: pattern.name,
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      textDirection: ui.TextDirection.rtl,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.width / 2 - textPainter.width / 2, size.height - 30));
  }

  @override
  bool shouldRepaint(PatternPainter oldDelegate) => false;
}

// استيراد Measurements
import '../models/measurement.dart';
