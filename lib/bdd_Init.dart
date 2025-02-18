import 'dart:io';
import 'package:appli_tp1/Type_donnee/artiste.dart';
import 'package:appli_tp1/Type_donnee/musee.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Type_donnee/oeuvre.dart';

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

  Future<List<Oeuvre>> getProduits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('oeuvre');
    return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  }

  Future<List<Oeuvre>> getAllOeuvres() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produits');

    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Oeuvre.fromMap(map)).toList();
  }

  Future<List<Artistes>> getAllArtistes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produits');

    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Artistes.fromMap(map)).toList();
  }

  Future<List<Musees>> getAllMusees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('produits');

    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Musees.fromMap(map)).toList();
  }

  Future<int> ajouterOeuvre(String nom, String description, double prix) async {
    final db = await database;
    Oeuvre oeuvre = Oeuvre(nom: nom, description: description, prix: prix);
    return await db.insert(
      'oeuvre',
      oeuvre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> ajouterartiste(String nom, String description, double prix) async {
    final db = await database;
    Artistes artiste = Artistes(nom: nom, description: description, prix: prix);
    return await db.insert(
      'artiste',
      artiste.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> ajouterMusees(String nom, String description, double prix) async {
    final db = await database;
    Musees musee = Musees(nom: nom, description: description, prix: prix);
    return await db.insert(
      'musée',
      musee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
