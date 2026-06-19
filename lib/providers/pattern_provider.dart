import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/pattern.dart';
import '../models/measurement.dart';
import '../services/database_service.dart';

class PatternProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Pattern> _patterns = [];
  Pattern? _currentPattern;
  Measurements? _currentMeasurements;

  List<Pattern> get patterns => _patterns;
  Pattern? get currentPattern => _currentPattern;
  Measurements? get currentMeasurements => _currentMeasurements;

  Future<void> initializeDatabase() async {
    await _databaseService.initDatabase();
    await loadPatterns();
  }

  // تحميل جميع الباترونات
  Future<void> loadPatterns() async {
    _patterns = await _databaseService.getAllPatterns();
    notifyListeners();
  }

  // إنشاء باترون جديد
  Future<void> createPattern({
    required String name,
    required DressType type,
    required Measurements measurements,
    String notes = '',
  }) async {
    final pattern = Pattern(
      id: const Uuid().v4(),
      name: name,
      type: type,
      measurements: measurements,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      notes: notes,
    );

    await _databaseService.insertPattern(pattern);
    _currentPattern = pattern;
    _currentMeasurements = measurements;
    await loadPatterns();
  }

  // تحديث باترون موجود
  Future<void> updatePattern(Pattern pattern) async {
    final updatedPattern = pattern.copyWith(
      lastModified: DateTime.now(),
    );
    await _databaseService.updatePattern(updatedPattern);
    _currentPattern = updatedPattern;
    await loadPatterns();
  }

  // حذف باترون
  Future<void> deletePattern(String patternId) async {
    await _databaseService.deletePattern(patternId);
    if (_currentPattern?.id == patternId) {
      _currentPattern = null;
      _currentMeasurements = null;
    }
    await loadPatterns();
  }

  // تحميل باترون معين
  Future<void> loadPattern(String patternId) async {
    _currentPattern = await _databaseService.getPattern(patternId);
    _currentMeasurements = _currentPattern?.measurements;
    notifyListeners();
  }

  // إنشاء باترون من قالب
  Future<void> createPatternFromTemplate({
    required String name,
    required PatternTemplate template,
    String notes = '',
  }) async {
    final measurements = Measurements(values: template.defaultMeasurements);
    await createPattern(
      name: name,
      type: template.type,
      measurements: measurements,
      notes: notes,
    );
  }

  // تحديث المقاسات للباترون الحالي
  void updateCurrentMeasurements(Map<String, double> values) {
    _currentMeasurements = Measurements(values: values);
    notifyListeners();
  }

  // الحصول على اسم نوع الفستان
  String getDressTypeName(DressType type) {
    switch (type) {
      case DressType.abaya:
        return 'عباية';
      case DressType.simpleDress:
        return 'فستان بسيط';
      case DressType.topAndSkirt:
        return 'توب وتنورة';
      case DressType.layeredDress:
        return 'فستان متعدد الطبقات';
      case DressType.traditionalDress:
        return 'فستان تقليدي';
    }
  }

  @override
  void dispose() {
    _databaseService.closeDatabase();
    super.dispose();
  }
}
