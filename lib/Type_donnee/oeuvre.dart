class Oeuvre {
  final int? id;
  final String nom;
  final String description;
  final double prix;

  Oeuvre({
    this.id,
    required this.nom,
    required this.description,
    required this.prix,
  });

  factory Oeuvre.fromMap(Map<String, dynamic> map) {
    return Oeuvre(
      id: map['id'],
      nom: map['nom'],
      description: map['description'],
      prix: map['prix'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'description': description,
      'prix': prix,
    };
  }
}
