import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/oeuvre.dart';

class OeuvrePage extends StatefulWidget {
  const OeuvrePage({super.key});

  @override
  State<OeuvrePage> createState() => _OeuvrePageState();
}

class _OeuvrePageState extends State<OeuvrePage> {
  late Future<List<Oeuvre>> _oeuvres;

  @override
  void initState() {
    super.initState();
    _oeuvres = DatabaseHelper.instance.getOeuvres();
    _oeuvres.then((oeuvres) {
    }).catchError((e) {
      print("Erreur lors de la récupération des œuvres: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des œuvres'),
      ),
      body: FutureBuilder<List<Oeuvre>>(
        future: _oeuvres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune œuvre trouvée.'));
          }

          final oeuvres = snapshot.data!;
          return ListView.builder(
            itemCount: oeuvres.length,
            itemBuilder: (context, index) {
              final oeuvre = oeuvres[index]; 
              /*
              print('URL de l\'image : ${oeuvre.photo}');
              String photoUrl = oeuvre.photo;
              try {
                final Uri uri = Uri.parse(photoUrl);
                if (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https')) {
                  print('URL valide : $photoUrl');
                } else {
                  print('URL invalide : $photoUrl');
                }
              } catch (e) {
                print('Erreur lors du parsing de l\'URL : $photoUrl');
              }
              String encodedUrl = Uri.encodeFull(photoUrl);*/
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Image à gauche
                    oeuvre.photo.isNotEmpty
                        ? Image.network(oeuvre.photo, width: 100, height: 100, fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported, size: 100),  // Icon si pas d'image
                    
                    // Informations à droite
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(oeuvre.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Auteur: ${oeuvre.auteur}'),
                            Text('Date de création: ${oeuvre.dateCreation}'),
                            Text('Musée: ${oeuvre.musee}'),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        oeuvre.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: oeuvre.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          oeuvre.isFavorite = !oeuvre.isFavorite; 
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
  List<Oeuvre> getFavorites(List<Oeuvre> oeuvres) {
    return oeuvres.where((oeuvre) => oeuvre.isFavorite).toList();
  }
}
