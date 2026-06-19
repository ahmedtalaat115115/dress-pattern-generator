import 'measurement.dart';

enum DressType {
  abaya,
  simpleDress,
  topAndSkirt,
  layeredDress,
  traditionalDress,
}

class Pattern {
  final String id;
  final String name;
  final DressType type;
  final Measurements measurements;
  final DateTime createdAt;

  Pattern({
    required this.id,
    required this.name,
    required this.type,
    required this.measurements,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'measurements': measurements.toMap(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Pattern.fromMap(Map<String, dynamic> map) {
    return Pattern(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: DressType.values.firstWhere(
        (type) => type.toString() == map['type'],
        orElse: () => DressType.simpleDress,
      ),
      measurements: Measurements.fromMap(map['measurements'] ?? {}),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class PatternTemplate {
  final String id;
  final String name;
  final String description;
  final DressType type;
  final Map<String, double> defaultMeasurements;

  PatternTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.defaultMeasurements,
  });
}

final List<PatternTemplate> predefinedTemplates = [
  PatternTemplate(
    id: 'abaya',
    name: 'عباية',
    description: 'عباية تقليدية',
    type: DressType.abaya,
    defaultMeasurements: {
      'height': 150,
      'chestCircumference': 90,
      'waistCircumference': 75,
      'hipCircumference': 100,
      'shoulderWidth': 40,
      'armLength': 60,
      'neckCircumference': 35,
      'chestDepth': 20,
      'backWidth': 35,
      'sleeveLength': 58,
    },
  ),
  PatternTemplate(
    id: 'simple_dress',
    name: 'فستان بسيط',
    description: 'فستان كاجوال',
    type: DressType.simpleDress,
    defaultMeasurements: {
      'height': 160,
      'chestCircumference': 85,
      'waistCircumference': 70,
      'hipCircumference': 95,
      'shoulderWidth': 38,
      'armLength': 55,
      'neckCircumference': 33,
      'chestDepth': 18,
      'backWidth': 33,
      'sleeveLength': 50,
    },
  ),
  PatternTemplate(
    id: 'top_skirt',
    name: 'توب وتنورة',
    description: 'توب مع تنورة',
    type: DressType.topAndSkirt,
    defaultMeasurements: {
      'height': 165,
      'chestCircumference': 80,
      'waistCircumference': 65,
      'hipCircumference': 90,
      'shoulderWidth': 36,
      'armLength': 52,
      'neckCircumference': 32,
      'chestDepth': 16,
      'backWidth': 32,
      'sleeveLength': 45,
    },
  ),
];
