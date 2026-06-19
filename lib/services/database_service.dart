import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pattern.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dress_patterns.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE patterns (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type INTEGER NOT NULL,
        measurements TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        lastModified TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  // إدراج باترون جديد
  Future<void> insertPattern(Pattern pattern) async {
    final db = await database;
    await db.insert(
      'patterns',
      {
        'id': pattern.id,
        'name': pattern.name,
        'type': pattern.type.index,
        'measurements': _serializeMeasurements(pattern.measurements),
        'createdAt': pattern.createdAt.toIso8601String(),
        'lastModified': pattern.lastModified.toIso8601String(),
        'notes': pattern.notes,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // تحديث باترون
  Future<void> updatePattern(Pattern pattern) async {
    final db = await database;
    await db.update(
      'patterns',
      {
        'name': pattern.name,
        'measurements': _serializeMeasurements(pattern.measurements),
        'lastModified': pattern.lastModified.toIso8601String(),
        'notes': pattern.notes,
      },
      where: 'id = ?',
      whereArgs: [pattern.id],
    );
  }

  // حذف باترون
  Future<void> deletePattern(String patternId) async {
    final db = await database;
    await db.delete(
      'patterns',
      where: 'id = ?',
      whereArgs: [patternId],
    );
  }

  // الحصول على باترون واحد
  Future<Pattern?> getPattern(String patternId) async {
    final db = await database;
    final result = await db.query(
      'patterns',
      where: 'id = ?',
      whereArgs: [patternId],
    );

    if (result.isEmpty) return null;
    return _patternFromMap(result.first);
  }

  // الحصول على جميع الباترونات
  Future<List<Pattern>> getAllPatterns() async {
    final db = await database;
    final result = await db.query('patterns');
    return result.map((map) => _patternFromMap(map)).toList();
  }

  Pattern _patternFromMap(Map<String, dynamic> map) {
    return Pattern(
      id: map['id'] as String,
      name: map['name'] as String,
      type: DressType.values[map['type'] as int],
      measurements: _deserializeMeasurements(map['measurements'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastModified: DateTime.parse(map['lastModified'] as String),
      notes: map['notes'] as String? ?? '',
    );
  }

  String _serializeMeasurements(Measurements measurements) {
    // تحويل المقاسات إلى JSON
    final json = measurements.toJson();
    return json.entries.map((e) => '${e.key}:${e.value}').join(',');
  }

  Measurements _deserializeMeasurements(String serialized) {
    // تحويل من JSON إلى Measurements
    final Map<String, double> values = {};
    final parts = serialized.split(',');
    for (final part in parts) {
      final keyValue = part.split(':');
      if (keyValue.length == 2) {
        values[keyValue[0]] = double.parse(keyValue[1]);
      }
    }
    return Measurements(values: values);
  }

  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  Future<void> initDatabase() async {
    await database;
  }
}
