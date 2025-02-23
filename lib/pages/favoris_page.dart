import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/artiste.dart'; 


class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  late Future<List<Artistes>> _artistes;
  //final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _artistes = DatabaseHelper.instance.getArtistes(); 
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
