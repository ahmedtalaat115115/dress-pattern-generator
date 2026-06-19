import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pattern.dart';
import '../models/measurement.dart';
import '../providers/pattern_provider.dart';
import 'pattern_display_screen.dart';
import 'fabric_calculator_screen.dart';

class NewPatternScreen extends StatefulWidget {
  const NewPatternScreen({Key? key}) : super(key: key);

  @override
  State<NewPatternScreen> createState() => _NewPatternScreenState();
}

class _NewPatternScreenState extends State<NewPatternScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DressType? _selectedType;
  PatternTemplate? _selectedTemplate;
  final Map<String, TextEditingController> _measurementControllers = {};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _initializeMeasurementControllers();
  }

  void _initializeMeasurementControllers() {
    for (var key in Measurements.requiredMeasurements) {
      _measurementControllers[key] = TextEditingController();
    }
  }

  void _loadTemplate(PatternTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _selectedType = template.type;
      for (var entry in template.defaultMeasurements.entries) {
        _measurementControllers[entry.key]?.text = entry.value.toString();
      }
    });
  }

  void _createPattern() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اختر نوع الفستان')),
      );
      return;
    }

    final measurements = <String, double>{};
    for (var entry in _measurementControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        measurements[entry.key] = double.parse(entry.value.text);
      }
    }

    if (measurements.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('أدخل المقاسات')),
      );
      return;
    }

    await context.read<PatternProvider>().createPattern(
      name: _nameController.text,
      type: _selectedType!,
      measurements: Measurements(values: measurements),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إنشاء الباترون بنجاح')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('باترون جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // اسم الباترون
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم الباترون',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'أدخل اسم الباترون';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // القوالب الجاهزة
              Text(
                'استخدم قالب جاهز',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: predefinedTemplates.length,
                  itemBuilder: (context, index) {
                    final template = predefinedTemplates[index];
                    final isSelected = _selectedTemplate?.id == template.id;
                    return GestureDetector(
                      onTap: () => _loadTemplate(template),
                      child: Card(
                        color: isSelected ? Colors.purple : Colors.white,
                        margin: const EdgeInsets.only(right: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                template.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                template.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected ? Colors.white70 : Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // نوع الفستان
              Text(
                'نوع الفستان',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DressType>(
                value: _selectedType,
                items: DressType.values.map((type) {
                  final names = {
                    DressType.abaya: 'عباية',
                    DressType.simpleDress: 'فستان بسيط',
                    DressType.topAndSkirt: 'توب وتنورة',
                    DressType.layeredDress: 'فستان متعدد الطبقات',
                    DressType.traditionalDress: 'فستان تقليدي',
                  };
                  return DropdownMenuItem(
                    value: type,
                    child: Text(names[type] ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedType = value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // المقاسات
              Text(
                'أدخل المقاسات (بالسنتيمتر)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...Measurements.requiredMeasurements.map((key) {
                final label = Measurements.measurementNames[key] ?? key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextFormField(
                    controller: _measurementControllers[key],
                    decoration: InputDecoration(
                      labelText: label,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixText: 'سم',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'أدخل $label';
                      }
                      if (double.tryParse(value!) == null) {
                        return 'أدخل رقماً صحيحاً';
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),

              // أزرار الإجراء
              ElevatedButton(
                onPressed: _createPattern,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('إنشاء الباترون'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
