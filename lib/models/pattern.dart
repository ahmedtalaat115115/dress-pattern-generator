import 'measurement.dart';

enum DressType {
  abaya, // عباية
  simpleDress, // فستان بسيط
  topAndSkirt, // توب وتنورة
  layeredDress, // فستان متعدد الطبقات
  traditionalDress, // فستان تقليدي
}

class Pattern {
  final String id;
  final String name; // اسم الباترون
  final DressType type;
  final Measurements measurements;
  final DateTime createdAt;
  final DateTime lastModified;
  final String notes; // ملاحظات

  Pattern({
    required this.id,
    required this.name,
    required this.type,
    required this.measurements,
    required this.createdAt,
    required this.lastModified,
    this.notes = '',
  });

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      id: json['id'] as String,
      name: json['name'] as String,
      type: DressType.values[json['type'] as int],
      measurements: Measurements.fromJson(json['measurements'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'measurements': measurements.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'notes': notes,
    };
  }

  Pattern copyWith({
    String? id,
    String? name,
    DressType? type,
    Measurements? measurements,
    DateTime? createdAt,
    DateTime? lastModified,
    String? notes,
  }) {
    return Pattern(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      measurements: measurements ?? this.measurements,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      notes: notes ?? this.notes,
    );
  }
}

class PatternTemplate {
  final String id;
  final String name; // اسم القالب
  final DressType type;
  final Map<String, double> defaultMeasurements; // المقاسات الافتراضية
  final String description; // وصف القالب

  PatternTemplate({
    required this.id,
    required this.name,
    required this.type,
    required this.defaultMeasurements,
    this.description = '',
  });
}

// قوالب جاهزة
final List<PatternTemplate> predefinedTemplates = [
  PatternTemplate(
    id: 'abaya_simple',
    name: 'عباية بسيطة',
    type: DressType.abaya,
    description: 'عباية بسيطة وكلاسيكية',
    defaultMeasurements: {
      'height': 155,
      'chestCircumference': 100,
      'waistCircumference': 90,
      'hipCircumference': 105,
      'shoulderWidth': 38,
      'armLength': 58,
      'neckCircumference': 36,
      'chestDepth': 20,
      'backWidth': 35,
      'sleeveLength': 60,
    },
  ),
  PatternTemplate(
    id: 'dress_simple',
    name: 'فستان بسيط',
    type: DressType.simpleDress,
    description: 'فستان بسيط ومريح',
    defaultMeasurements: {
      'height': 160,
      'chestCircumference': 95,
      'waistCircumference': 75,
      'hipCircumference': 100,
      'shoulderWidth': 36,
      'armLength': 56,
      'neckCircumference': 34,
      'chestDepth': 22,
      'backWidth': 33,
      'sleeveLength': 58,
    },
  ),
  PatternTemplate(
    id: 'top_skirt',
    name: 'توب وتنورة',
    type: DressType.topAndSkirt,
    description: 'توب وتنورة منفصلة',
    defaultMeasurements: {
      'height': 160,
      'chestCircumference': 92,
      'waistCircumference': 72,
      'hipCircumference': 98,
      'shoulderWidth': 35,
      'armLength': 55,
      'neckCircumference': 33,
      'chestDepth': 21,
      'backWidth': 32,
      'sleeveLength': 57,
    },
  ),
];
