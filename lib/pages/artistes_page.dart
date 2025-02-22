// lib/pages/artistes_page.dart
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
    _artistes = DatabaseHelper.instance.getAllArtistes();
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
                  title: Text(artiste.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(artiste.description),
                  trailing: Text(
                    '${artiste.prix.toStringAsFixed(2)} €',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
