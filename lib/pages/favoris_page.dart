import 'package:appli_tp1/Type_donnee/artiste.dart';
import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/musee.dart'; 
import '/Type_donnee/oeuvre.dart';


class FavorisPage extends StatefulWidget {
  @override
  _FavorisPageState createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  late Future<List<Oeuvre>> _oeuvres;
  late Future<List<Musee>> _musees;
  late Future<List<Artistes>> _artistes;

  @override
  void initState() {
    super.initState();
    _musees = DatabaseHelper.instance.getMusees(); 
    _musees.then((musee) {
    }).catchError((e) {
      print("Erreur lors de la récupération des œuvres: $e");
    });
    _oeuvres = DatabaseHelper.instance.getOeuvres();
    _oeuvres.then((oeuvres) {
    }).catchError((e) {
      print("Erreur lors de la récupération des œuvres: $e");
    });
    _artistes = DatabaseHelper.instance.getArtistes();
    _artistes.then((artistes) {
    }).catchError((e) {
      print("Erreur lors de la récupération des œuvres: $e");
    });
    loadFavorites();
  }

  List<Oeuvre> favoriteOeuvre = [];
  List<Musee> favoriteMusee = [];
  List<Artistes> favoriteArtiste = [];


  Future<void> loadFavorites() async {
    final oeuvres = await _oeuvres;
    final musees = await _musees;
    final artistes = await _artistes;
    for (var o in oeuvres) {
      await o.loadFavoriteState();
      if (o.isFavorite) {
        favoriteOeuvre.add(o);
      }
    }
    for (var m in musees) {
      await m.loadFavoriteState();
      if (m.isFavorite) {
        favoriteMusee.add(m);
      }
    }
    for (var a in artistes) {
      await a.loadFavoriteState();
      if (a.isFavorite) {
        favoriteArtiste.add(a);
      }
    }
    setState(() {});  // Actualiser l'UI avec les favoris
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoris')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section des Œuvres favorites
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Œuvres Favorites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteOeuvre.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Image à gauche
                      favoriteOeuvre[index].photo.isNotEmpty
                          ? Image.network(favoriteOeuvre[index].photo, width: 100, height: 100, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported, size: 100),  // Icon si pas d'image
                      
                      // Informations à droite
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(favoriteOeuvre[index].nom, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Auteur: ${favoriteOeuvre[index].auteur}'),
                              Text('Date de création: ${favoriteOeuvre[index].dateCreation}'),
                              Text('Musée: ${favoriteOeuvre[index].musee}'),
                            ],
                          ),
                        ),
                      )
                    ]
                  )
                );
              },
            ),
            // Section des Artistes favoris
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Artistes Favoris', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteArtiste.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Image à gauche
                      favoriteArtiste[index].photo.isNotEmpty
                          ? Image.network(favoriteArtiste[index].photo, width: 100, height: 100, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported, size: 100),  // Icon si pas d'image
                      
                      // Informations à droite
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(favoriteArtiste[index].nom, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Date de naissance: ${favoriteArtiste[index].dateNaissance}'),
                              Text('Date de Déces: ${favoriteArtiste[index].dateDeces} '),
                              Text('style: ${favoriteArtiste[index].styleArt}'),
                            ],
                          ),
                        ),
                      )
                    ]
                  )
                );
              },
            ),
            // Section des Musées favoris
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Musées Favoris', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: favoriteMusee.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      // Image à gauche
                      favoriteMusee[index].logo.isNotEmpty
                          ? Image.network(favoriteMusee[index].logo, width: 100, height: 100, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported, size: 100),  // Icon si pas d'image
                      
                      // Informations à droite
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(favoriteMusee[index].nom, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('Date de création: ${favoriteMusee[index].dateCreation}'),
                            Text('Adresse: ${favoriteMusee[index].adresse}'),
                            ],
                          ),
                        ),
                      )
                    ]
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
