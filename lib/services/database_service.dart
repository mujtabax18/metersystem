import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/meter.dart';

// Assuming the Meter and Reading models are in this file

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }


  // StreamControllers for listening to changes
  final StreamController<List<Meter>> _meterStreamController =
  StreamController.broadcast();
  final StreamController<List<Reading>> _readingStreamController =
  StreamController.broadcast();

  // static Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await _initDatabase();
  //   return _database!;
  // }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meter_readings.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE meters (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            number TEXT NOT NULL,
            baseline INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE readings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            value INTEGER NOT NULL,
            date TEXT NOT NULL,
            meter_id INTEGER NOT NULL,
            FOREIGN KEY (meter_id) REFERENCES meters (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Stream getters
  Stream<List<Meter>> get meterStream => _meterStreamController.stream;
  Stream<List<Reading>> get readingStream => _readingStreamController.stream;

  // CRUD for Meter
  Future<int> addMeter(Meter meter) async {
    final db = await database;
    int id = await db.insert('meters', meter.toJson());
    print('meter id: $id');
    _refreshMeters();
    return id;
  }

  Future<List<Meter>> getAllMeters() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('meters');

    return result.map((json) => Meter.fromJson(json)).toList();
  }

  Future<int> updateMeter(Meter meter) async {
    final db = await database;
    int result = await db.update(
      'meters',
      meter.toJson(),
      where: 'id = ?',
      whereArgs: [meter.id],
    );
    _refreshMeters();
    return result;
  }

  Future<int> deleteMeter(int? id) async {
    final db = await database;
    int result = await db.delete('meters', where: 'id = ?', whereArgs: [id]);
    _refreshMeters();
    return result;
  }

  // CRUD for Reading
  Future<int> addReading(Reading reading) async {
    final db = await database;
    int id = await db.insert('readings', reading.toJson());
    _refreshReadings(reading.meterId);
    return id;
  }

  Future<List<Reading>> getReadingsForMeter(int meterId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'readings',
      where: 'meter_id = ?',
      whereArgs: [meterId],
    );
    return result.map((json) => Reading.fromJson(json)).toList();
  }

  Future<int> updateReading(Reading reading) async {
    final db = await database;
    int result = await db.update(
      'readings',
      reading.toJson(),
      where: 'id = ?',
      whereArgs: [reading.id],
    );
    _refreshReadings(reading.meterId);
    return result;
  }

  Future<int> deleteReading(int? id, int meterId) async {
    final db = await database;
    int result = await db.delete('readings', where: 'id = ?', whereArgs: [id]);
    _refreshReadings(meterId);
    return result;
  }

  // Helper to refresh meters in the stream
  Future<void> _refreshMeters() async {
    List<Meter> meters = await getAllMeters();
    _meterStreamController.add(meters);
  }

  // Helper to refresh readings in the stream
  Future<void> _refreshReadings(int meterId) async {
    List<Reading> readings = await getReadingsForMeter(meterId);
    _readingStreamController.add(readings);
  }
  Future<void> updateMeterBaseline(int meterId, int baseline) async {
    final db = await database;
    await db.update(
      'meters',
      {'baseline': baseline},
      where: 'id = ?',
      whereArgs: [meterId],
    );
  }

  // Dispose streams when done
  void dispose() {
    _meterStreamController.close();
    _readingStreamController.close();
  }
}
