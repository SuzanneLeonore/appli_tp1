class Oeuvre {
  final int? id;
  final String photo;        
  final String nom;          
  final String dateCreation; 
  final String auteur;       
  final String musee;        

  Oeuvre({
    this.id,
    required this.photo,
    required this.nom,
    required this.dateCreation,
    required this.auteur,
    required this.musee,
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
}
