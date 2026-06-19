import '../models/pattern.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  // Mock database - في الإنتاج، استخدم sqflite
  final List<Pattern> _mockDatabase = [];

  Future<void> createPattern(Pattern pattern) async {
    _mockDatabase.add(pattern);
  }

  Future<List<Pattern>> getAllPatterns() async {
    return _mockDatabase;
  }

  Future<Pattern?> getPattern(String id) async {
    try {
      return _mockDatabase.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePattern(String id) async {
    _mockDatabase.removeWhere((p) => p.id == id);
  }

  Future<void> updatePattern(Pattern pattern) async {
    final index = _mockDatabase.indexWhere((p) => p.id == pattern.id);
    if (index != -1) {
      _mockDatabase[index] = pattern;
    }
  }
}
