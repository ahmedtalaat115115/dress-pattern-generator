import 'package:flutter/material.dart';
import '../models/pattern.dart';
import '../models/fabric.dart';

class FabricCalculatorScreen extends StatefulWidget {
  final Pattern pattern;

  const FabricCalculatorScreen({
    Key? key,
    required this.pattern,
  }) : super(key: key);

  @override
  State<FabricCalculatorScreen> createState() => _FabricCalculatorScreenState();
}

class _FabricCalculatorScreenState extends State<FabricCalculatorScreen> {
  FabricType? _selectedFabric;
  late TextEditingController _patternAreaController;
  double? _fabricLength;

  @override
  void initState() {
    super.initState();
    _patternAreaController = TextEditingController();
    _selectedFabric = commonFabrics.first;
  }

  void _calculateFabric() {
    if (_patternAreaController.text.isEmpty || _selectedFabric == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل مساحة الباترون واختر نوع القماش')),
      );
      return;
    }

    final patternArea = double.parse(_patternAreaController.text);
    final calculation = FabricCalculation(
      patternArea: patternArea,
      fabricWidth: _selectedFabric!.width,
      wasteFactor: _selectedFabric!.wasteFactor,
    );

    setState(() {
      _fabricLength = calculation.getFabricLengthInMeters();
    });
  }

  @override
  void dispose() {
    _patternAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حساب الخامة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // اختيار نوع القماش
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'نوع القماش',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<FabricType>(
                      value: _selectedFabric,
                      items: commonFabrics.map((fabric) {
                        return DropdownMenuItem(
                          value: fabric,
                          child: Text(fabric.arabicName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedFabric = value);
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // معلومات القماش المختار
            if (_selectedFabric != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('اسم القماش', _selectedFabric!.arabicName),
                      _buildInfoRow('عرض القماش', '${_selectedFabric!.width} سم'),
                      _buildInfoRow(
                        'نسبة الهدر',
                        '${_selectedFabric!.wasteFactor}%',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // مساحة الباترون
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مساحة الباترون',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _patternAreaController,
                      decoration: InputDecoration(
                        labelText: 'أدخل مساحة الباترون',
                        hintText: 'بالسنتيمتر المربع (سم²)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixText: 'سم²',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // زر الحساب
            ElevatedButton(
              onPressed: _calculateFabric,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('احسب كمية الخامة'),
            ),
            const SizedBox(height: 20),

            // النتيجة
            if (_fabricLength != null)
              Card(
                color: Colors.purple.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'النتيجة',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'كمية الخامة المطلوبة',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_fabricLength!.toStringAsFixed(2)} متر',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '(حوالي ${(_fabricLength! * 1.09361).toStringAsFixed(2)} ياردة)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        'عرض القماش',
                        '${_selectedFabric!.width} سم',
                      ),
                      _buildInfoRow(
                        'نسبة الهدر المحسوبة',
                        '${_selectedFabric!.wasteFactor}%',
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
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
}
