class Measurement {
  final String id;
  final String name; // اسم المقاس
  final String arabicName;
  final double value; // القيمة بالسنتيمتر
  final String unit; // الوحدة (سم، بوصة)

  Measurement({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.value,
    this.unit = 'سم',
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as String,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String? ?? 'سم',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabicName': arabicName,
      'value': value,
      'unit': unit,
    };
  }
}

class Measurements {
  final Map<String, double> values;

  Measurements({required this.values});

  // المقاسات الأساسية المطلوبة
  static const List<String> requiredMeasurements = [
    'height', // الطول الكلي
    'chestCircumference', // محيط الصدر
    'waistCircumference', // محيط الخصر
    'hipCircumference', // محيط الأرداف
    'shoulderWidth', // عرض الكتفين
    'armLength', // طول الذراع
    'neckCircumference', // محيط الرقبة
    'chestDepth', // عمق الصدر
    'backWidth', // عرض الظهر
    'sleeveLength', // طول الكم
  ];

  static const Map<String, String> measurementNames = {
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

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      values: Map<String, double>.from(
        json.cast<String, double>(),
      ),
    );
  }

  Map<String, dynamic> toJson() => values;
}
