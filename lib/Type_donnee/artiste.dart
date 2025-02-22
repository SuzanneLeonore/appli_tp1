class Artistes {
  final int? id;
  final String nom;
  final String description;
  final double prix;

  Artistes({
    this.id,
    required this.nom,
    required this.description,
    required this.prix,
  });

  factory Artistes.fromMap(Map<String, dynamic> map) {
    return Artistes(
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

  @override
  String toString() {
    return 'Dog{id: $id, name: $nom, age: $description, prix: $prix}';
  }
}
