class Artistes {
  final int? id;
  final String photo;        
  final String nom;          
  final String dateNaissance; 
  final String? dateDeces;    
  final String styleArt;      

  Artistes({
    this.id,
    required this.photo,
    required this.nom,
    required this.dateNaissance,
    this.dateDeces,
    required this.styleArt,
  });

  factory Artistes.fromMap(Map<String, dynamic> map) {
    return Artistes(
      id: map['id'],
      photo: map['photo'],
      nom: map['nom'],
      dateNaissance: map['dateNaissance'],
      dateDeces: map['dateDeces'],
      styleArt: map['styleArt'],
    );
  }

  // Fonction pour convertir une instance d'Artistes en map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photo': photo,
      'nom': nom,
      'dateNaissance': dateNaissance,
      'dateDeces': dateDeces,
      'styleArt': styleArt,
    };
  }

  @override
  String toString() {
    return 'Artistes{id: $id, nom: $nom, dateNaissance: $dateNaissance, dateDeces: $dateDeces, styleArt: $styleArt}';
  }
}
