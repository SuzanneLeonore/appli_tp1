import 'package:shared_preferences/shared_preferences.dart';

class Musee {
  final int? id;
  final String logo;      
  final String nom;       
  final String dateCreation; 
  final String adresse;
  bool isFavorite;   
  
  Musee({
    this.id,
    required this.logo,
    required this.nom,
    required this.dateCreation,
    required this.adresse,
    this.isFavorite = false,
  });

  factory Musee.fromMap(Map<String, dynamic> map) {
    return Musee(
      logo: map['logo'],
      nom: map['nom'],
      dateCreation: map['dateCreation'],
      adresse: map['adresse'],
    );
  }

  // Fonction pour convertir une instance de Musee en map
  Map<String, dynamic> toMap() {
    return {
      'logo': logo,
      'nom': nom,
      'dateCreation': dateCreation,
      'adresse': adresse,
    };
  }

  Future<void> saveFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(nom, isFavorite);  // Utilise le nom du produit comme clé
  }

  Future<void> loadFavoriteState() async {
    final prefs = await SharedPreferences.getInstance();
    isFavorite = prefs.getBool(nom) ?? false;  // Par défaut, false si rien n'est sauvegardé
  }
}
