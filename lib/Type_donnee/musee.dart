class Musee {
  final String logo;      
  final String nom;       
  final String dateCreation; 
  final String adresse;   
  
  Musee({
    required this.logo,
    required this.nom,
    required this.dateCreation,
    required this.adresse,
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
}
