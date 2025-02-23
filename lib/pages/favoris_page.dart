import 'package:appli_tp1/Type_donnee/artiste.dart';
import 'package:flutter/material.dart';
import '/Type_donnee/musee.dart'; 
import '/Type_donnee/oeuvre.dart';
import 'favorisController.dart';


class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});


   @override
  Widget build(BuildContext context) {

    List<dynamic> favoris = FavorisController.getFavorites();

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoris"),
      ),
      body: ListView.builder(
        itemCount: favoris.length,
        itemBuilder: (context, index) {
          final item = favoris[index];
          if (item is Oeuvre) {
            return ListTile(
              title: Text(item.nom),
              subtitle: Text('Auteur: ${item.auteur}'),
            );
          } else if (item is Artistes) {
            return ListTile(
              title: Text(item.nom),
              subtitle: Text('Artiste favori'),
            );
          } else if (item is Musee) {
            return ListTile(
              title: Text(item.nom),
              subtitle: Text('Musée favori'),
            );
          } else {
            return Container(); // cas type non défini
          }
        },
      ),
    );
  }
}