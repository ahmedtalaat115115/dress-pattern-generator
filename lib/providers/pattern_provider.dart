import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/pattern.dart';
import '../models/measurement.dart';
import '../services/database_service.dart';

class PatternProvider extends ChangeNotifier {
  List<Pattern> _patterns = [];
  final DatabaseService _dbService = DatabaseService();

  List<Pattern> get patterns => _patterns;

  PatternProvider() {
    _loadPatterns();
  }

  Future<void> _loadPatterns() async {
    try {
      _patterns = await _dbService.getAllPatterns();
      notifyListeners();
    } catch (e) {
      print('Error loading patterns: $e');
    }
  }

  Future<void> createPattern({
    required String name,
    required DressType type,
    required Measurements measurements,
  }) async {
    try {
      final pattern = Pattern(
        id: const Uuid().v4(),
        name: name,
        type: type,
        measurements: measurements,
        createdAt: DateTime.now(),
      );

      await _dbService.createPattern(pattern);
      _patterns.add(pattern);
      notifyListeners();
    } catch (e) {
      print('Error creating pattern: $e');
    }
  }

  Future<void> deletePattern(String id) async {
    try {
      await _dbService.deletePattern(id);
      _patterns.removeWhere((pattern) => pattern.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting pattern: $e');
    }
  }

  String getDressTypeName(DressType type) {
    const names = {
      DressType.abaya: 'عباية',
      DressType.simpleDress: 'فستان بسيط',
      DressType.topAndSkirt: 'توب وتنورة',
      DressType.layeredDress: 'فستان متعدد الطبقات',
      DressType.traditionalDress: 'فستان تقليدي',
    };
    return names[type] ?? 'فستان';
  }
}
