class Measurements {
  final Map<String, double> values;

  Measurements({required this.values});

  static const List<String> requiredMeasurements = [
    'height',
    'chestCircumference',
    'waistCircumference',
    'hipCircumference',
    'shoulderWidth',
    'armLength',
    'neckCircumference',
    'chestDepth',
    'backWidth',
    'sleeveLength',
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

  Map<String, dynamic> toMap() {
    return {
      'values': values,
    };
  }

  factory Measurements.fromMap(Map<String, dynamic> map) {
    final valuesMap = (map['values'] as Map?)?.cast<String, double>() ?? {};
    return Measurements(values: valuesMap);
  }
}
