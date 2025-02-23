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
      print("Oeuvres récupérées: $oeuvres");
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
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Image.network(oeuvre.photo, width: 50, height: 50, fit: BoxFit.cover), 
                  title: Text(oeuvre.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Créée le : ${oeuvre.dateCreation}', style: const TextStyle(fontSize: 14)),
                      Text('Auteur : ${oeuvre.auteur}', style: const TextStyle(fontSize: 14)),
                      Text('Musée : ${oeuvre.musee}', style: const TextStyle(fontSize: 14)),
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
