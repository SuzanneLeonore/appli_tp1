import 'package:shared_preferences/shared_preferences.dart';

class Oeuvre {
  final int? id;
  final String photo;        
  final String nom;          
  final String dateCreation; 
  final String auteur;       
  final String musee; 
  bool isFavorite;       

  Oeuvre({
    this.id,
    required this.photo,
    required this.nom,
    required this.dateCreation,
    required this.auteur,
    required this.musee,
    this.isFavorite = false,
  });


  factory Oeuvre.fromMap(Map<String, dynamic> map) {
    return Oeuvre(
      id: map['id'],
      photo: map['photo'],
      nom: map['nom'],
      dateCreation: map['dateCreation'],
      auteur: map['auteur'],
      musee: map['musee'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'nom': nom,
      'dateCreation': dateCreation,
      'auteur': auteur,
      'musee': musee,
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
