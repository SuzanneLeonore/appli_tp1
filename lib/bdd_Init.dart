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
    print("💬 Initialisation de la base de données...");
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
      print("➡️ Début de l'initialisation de la base de données...");
      final databasePath = kIsWeb ? 'catalogue.db' : join(await getDatabasesPath(), 'catalogue.db');
      print("📦 Chemin de la base de données : $databasePath");
      
      final db = await openDatabase(databasePath, version: 1, onCreate: (db, version) async {
        print("✅ BDD créée (sans exécuter le fichier SQL)");
      });
      print("✅ Base de données ouverte avec succès !");
      await _loadSqlFromAssetsAndExecute(db);
      return db;
    } catch (e) {
      print("❌ Erreur lors de l'initialisation de la base de données : $e");
      rethrow;
    }
  }

  Future<void> _loadSqlFromAssetsAndExecute(Database db) async {
    try {
      // Charger le fichier SQL depuis les assets
      String sql = await _loadSqlFromAsset('assets/catalogue.sql');
      print("📄 SQL chargé : $sql");

      // Diviser le fichier SQL en instructions séparées
      List<String> statements = sql.split(';');

      // Exécuter chaque instruction SQL
      for (var statement in statements) {
        if (statement.trim().isNotEmpty) {
          try {
            await db.execute(statement.trim());
            print("✅ Exécution de la requête SQL : $statement");
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
      print("❌ Erreur lors du chargement du fichier SQL depuis les assets : $e");
      rethrow;
    }
  }




  void addTask(String content) async{
    final db = await database;
    await db.insert(
      'oeuvres',
      {
        'text': content,
        'taille':0, 
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Oeuvre>> getOeuvres() async {
      final db = await database;
      final data = await db.query('oeuvres');
      List<Oeuvre> oeuvres= data.map((e)=> Oeuvre(
        photo : e["photo"] as String,
        nom: e["nom"] as String, 
        dateCreation : e["dateCreation"] as String, 
        auteur: e["auteur"] as String,
        musee : e["musee"] as String,
      ),
      )
      .toList();
      //final List<Map<String, dynamic>> maps = await db.query('oeuvres');
      //return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  return oeuvres;
  }

  Future<List<Artistes>> getArtistes() async {
      final db = await database;
      final data = await db.query('artistes');
      List<Artistes> artistes= data.map((e)=> Artistes(
        photo : e["photo"] as String,
        nom: e["nom"] as String, 
        dateNaissance : e["dateNaissance"] as String, 
        dateDeces : e["dateDeces"] as String, 
        styleArt: e["styleArt"] as String,
      ),
      )
      .toList();
      //final List<Map<String, dynamic>> maps = await db.query('oeuvres');
      //return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  return artistes;
  }

  Future<List<Musee>> getMusees() async {
      final db = await database;
      final data = await db.query('musees');
      List<Musee> musees= data.map((e)=> Musee(
        logo : e["logo"] as String,
        nom: e["nom"] as String, 
        dateCreation : e["dateCreation"] as String, 
        adresse: e["adresse"] as String, 
      ),
      )
      .toList();
      //final List<Map<String, dynamic>> maps = await db.query('oeuvres');
      //return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  return musees;
  }

  

}

/*
class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._constructor();

  DatabaseHelper._constructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    print("Début de l'initialisation de la base de données");

    // Initialisation de databaseFactory en fonction de la plateforme
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb; // Utilisation sur le web
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi; // Utilisation sur desktop
    }

    // Définir le chemin de la base de données
    String path;
    if (kIsWeb) {
      path = 'catalogue.db';  // Sur le web, fichier 
    } else {
      path = join(await getDatabasesPath(), 'catalogue.db'); // Sur les plateformes locales
    }

    print("Chemin complet de la base de données : $path");

    try {
      bool dbExists = await databaseExists(path);
      print("Résultat : ${dbExists ? 'existe' : 'n\'existe pas'}");

      // Si la base de données n'existe pas encore
      if (!dbExists) {
        print("La base de données n'existe pas");
        print("Création bdd");

        // Chargement du fichier SQL
        try {
          ByteData data = await rootBundle.load('assets/catalogue.sql');
          String sql = String.fromCharCodes(data.buffer.asUint8List());
          print("Contenu du fichier SQL chargé : $sql");
          
          if (sql.isEmpty) {
            print("Le fichier SQL est vide ou n'a pas pu être chargé correctement.");
          }
          
          // Créer la base de données avec openDatabase
          Database db = await openDatabase(path, version: 1, onCreate: (db, version) async {
            print("Exécution des commandes SQL");

            // Décomposer les requêtes SQL
            List<String> queries = sql.split(';');
            for (var query in queries) {
              if (query.trim().isNotEmpty) {
                try {
                  print("Exécution de la commande SQL : $query");
                  await db.execute(query);
                  print("Commande SQL exécutée : $query");
                } catch (e) {
                  print("Erreur lors de l'exécution de la commande SQL : $e");
                }
              }
            }
          });

          print('Base de données créée et initialisée.');
          return db;
        } catch (e) {
          print("Erreur lors du chargement du fichier SQL : $e");
          rethrow;
        }
      }

      // Si la base de données existe déjà, on l'ouvre simplement
      print('Base de données déjà existante.');
      return await openDatabase(path);
    } catch (e) {
      print("Erreur lors de l'initialisation de la base de données : $e");
      rethrow;
    }
  }



  Future<List<Oeuvre>> getProduits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('oeuvres');
    return maps.map((map) => Oeuvre.fromMap(map)).toList(); 
  }

  Future<List<Oeuvre>> getAllOeuvres() async {
    
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('oeuvre');
    print("object");
    print(maps);
    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Oeuvre.fromMap(map)).toList();
  }

  Future<List<Artistes>> getAllArtistes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('artistes');

    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Artistes.fromMap(map)).toList();
  }

  Future<List<Musees>> getAllMusees() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('musées');

    // Convertir la liste de Map en liste de Produits
    return maps.map((map) => Musees.fromMap(map)).toList();
  }

  Future<int> ajouterOeuvre(String nom, String description, double prix) async {
    final db = await database;
    Oeuvre oeuvre = Oeuvre(nom: nom, description: description, prix: prix);
    return await db.insert(
      'oeuvres',
      oeuvre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> ajouterartiste(String nom, String description, double prix) async {
    final db = await database;
    Artistes artiste = Artistes(nom: nom, description: description, prix: prix);
    return await db.insert(
      'artistes',
      artiste.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> ajouterMusees(String nom, String description, double prix) async {
    final db = await database;
    Musees musee = Musees(nom: nom, description: description, prix: prix);
    return await db.insert(
      'musées',
      musee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
*/