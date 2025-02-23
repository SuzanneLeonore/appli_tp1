import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'Type_donnee/oeuvre.dart';
import 'Type_donnee/artiste.dart';
import 'Type_donnee/musee.dart';

Future<void> initDatabaseFactory() async {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // pour le web
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // initialisation pour le desktop
    databaseFactory = databaseFactoryFfi;
  }
}

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  DatabaseHelper._constructor();

  Future<void> init() async {
    if (_database != null) return;
    await initDatabaseFactory();
    _database = await getDatabase();
  }

  Future<Database> get database async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }

  Future<Database> getDatabase() async {
    try {
      final databasePath = kIsWeb
          ? 'catalogue.db'
          : join(await getDatabasesPath(), 'catalogue.db');

      final db = await openDatabase(databasePath, version: 1,
          onCreate: (db, version) async {
      });
      await _loadSqlFromAssetsAndExecute(db);
      return db;
    } catch (e) {
      print("❌ Erreur lors de l'initialisation de la base de données : $e");
      rethrow;
    }
  }

  Future<void> _loadSqlFromAssetsAndExecute(Database db) async {
    try {
      String sql = await _loadSqlFromAsset('assets/catalogue.sql');
      List<String> statements = sql.split(';');
      for (var statement in statements) {
        if (statement.trim().isNotEmpty) {
          try {
            await db.execute(statement.trim());
          } catch (e) {
            print("❌ Erreur lors de l'exécution de la requête SQL : $e");
          }
        }
      }
    } catch (e) {
      print("❌ Erreur lors du chargement du fichier SQL : $e");
      rethrow;
    }
  }

  // Charger le contenu d'un fichier SQL depuis les assets
  Future<String> _loadSqlFromAsset(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final sql = String.fromCharCodes(byteData.buffer.asUint8List());
      return sql;
    } catch (e) {
      print(
          "❌ Erreur lors du chargement du fichier SQL depuis les assets : $e");
      rethrow;
    }
  }

  Future<List<Oeuvre>> getOeuvres() async {
    final db = await database;
    final data = await db.query('oeuvres');
    print(data);
    List<Oeuvre> oeuvres = data
        .map(
          (e) => Oeuvre(
            photo: e["image"] as String? ?? "image de l'oeuvre",
            nom: e["titre"] as String? ?? "val par défault",
            dateCreation: e["date_creation"] as String? ?? "val par default",
            auteur: e["auteur"] as String? ?? "val par default",
            musee: e["musee"] as String? ?? "val par default",
          ),
        )
        .toList();
    return oeuvres;
  }

  Future<List<Artistes>> getArtistes() async {
    final db = await database;
    final data = await db.query('artistes');
    List<Artistes> artistes = data
        .map(
          (e) => Artistes(
            photo: e["photo"] as String? ?? "photo artiste",
            nom: e["nom"] as String? ?? "val par default",
            dateNaissance: e["dateNaissance"] as String? ?? "val par default",
            dateDeces: e["dateDeces"] as String? ?? "val par default",
            styleArt: e["styleArt"] as String? ?? "val par default",
          ),
        )
        .toList();
    return artistes;
  }

  Future<List<Musee>> getMusees() async {
    final db = await database;
    final data = await db.query('musees');
    List<Musee> musees = data
        .map(
          (e) => Musee(
            logo: e["logo"] as String? ?? "logo du musee",
            nom: e["nom"] as String? ?? "val par defaut",
            dateCreation: e["dateCreation"] as String? ?? "val par defaut",
            adresse: e["adresse"] as String? ?? "val par defaut",
          ),
        )
        .toList();
    return musees;
  }
}