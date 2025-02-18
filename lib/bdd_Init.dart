import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'catalogue.db');

    if (!(await databaseExists(path))) {
      ByteData data = await rootBundle.load('assets/catalogue.sql');
      String sql = String.fromCharCodes(data.buffer.asUint8List());
      Database db = await openDatabase(path, version: 1, onCreate: (db, version) async {
        List<String> queries = sql.split(';');
        for (var query in queries) {
          if (query.trim().isNotEmpty) {
            await db.execute(query);
          }
        }
      });
      return db;
    }

    return await openDatabase(path);
  }

  Future<List<Map<String, dynamic>>> getProduits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('oeuvre');
    return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  }

  Future<int> ajouterProduit(String nom, String description, double prix) async {
    final db = await database;
    return await db.insert(
      'oeuvre',
      Oeuvre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
