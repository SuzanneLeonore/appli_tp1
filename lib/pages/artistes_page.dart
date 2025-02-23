import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '/bdd_Init.dart';  // Assure-toi que tu as une méthode pour récupérer les artistes depuis ta base de données
import '/Type_donnee/artiste.dart';  // Importe la classe Artistes


class ArtistesPage extends StatefulWidget {
  const ArtistesPage({super.key});

  @override
  State<ArtistesPage> createState() => _ArtistesPageState();
}

class _ArtistesPageState extends State<ArtistesPage> {
  late Future<List<Artistes>> _artistes;
  late Future<Database> _databaseFuture;

  @override
  void initState() {
    super.initState();
    _artistes = DatabaseHelper.instance.getArtistes(); 
    _databaseFuture = DatabaseHelper.instance.database;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: _databaseFuture
    , builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();  // Affiche un chargement
        } else if (snapshot.hasError) {
          return Text('Erreur: ${snapshot.error}');  // Affiche l'erreur s'il y en a une
        } else {
          return Text('Base de données ouverte !');  // Affiche un message si la base est prête
        }
      },
    );
    /*
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des artistes'),
      ),
      body: FutureBuilder<List<Artistes>>(
        future: _artistes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun artiste trouvé.'));
          }

          final artistes = snapshot.data!;
          return ListView.builder(
            itemCount: artistes.length,
            itemBuilder: (context, index) {
              final artiste = artistes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(artiste.photo), 
                    radius: 30,
                  ),
                  title: Text(artiste.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Naissance : ${artiste.dateNaissance}', 
                        style: const TextStyle(fontSize: 14),
                      ),
                      if (artiste.dateDeces != null)
                        Text(
                          'Décès : ${artiste.dateDeces}', 
                          style: const TextStyle(fontSize: 14),
                        ),
                      Text(
                        'Style : ${artiste.styleArt}', 
                        style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
    */
  }

}
