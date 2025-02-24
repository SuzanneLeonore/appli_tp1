import 'package:flutter/material.dart';
import '/bdd_Init.dart';  
import '/Type_donnee/artiste.dart';  

class ArtistesPage extends StatefulWidget {
  const ArtistesPage({super.key});

  @override
  State<ArtistesPage> createState() => _ArtistesPageState();
}

class _ArtistesPageState extends State<ArtistesPage> {
  late Future<List<Artistes>> _artistes;

  @override
  void initState() {
    super.initState();
    _artistes = DatabaseHelper.instance.getArtistes(); 
    _artistes.then((artistes) {
    }).catchError((e) {
      print("Erreur lors de la récupération des œuvres: $e");
    });
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
                margin: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Image à gauche
                    artiste.photo.isNotEmpty
                        ? Image.network(artiste.photo, width: 100, height: 100, fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported, size: 100),  // Icon si pas d'image
                    
                    // Informations à droite
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(artiste.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Date de naissance: ${artiste.dateNaissance}'),
                            Text('Date de Déces: ${artiste.dateDeces} '),
                            Text('style: ${artiste.styleArt}'),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        artiste.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: artiste.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          artiste.isFavorite = !artiste.isFavorite;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
  List<Artistes> getFavorites(List<Artistes> artiste) {
    return artiste.where((artiste) => artiste.isFavorite).toList();
  }
}
