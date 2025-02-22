// lib/pages/Favoris_page.dart
import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/artiste.dart';

class FavorisPage extends StatefulWidget {
  const FavorisPage({super.key});

  @override
  State<FavorisPage> createState() => _FavorisPageState();
}

class _FavorisPageState extends State<FavorisPage> {
  late Future<List<Artistes>> _Artistes;

  @override
  void initState() {
    super.initState();
    _Artistes = DatabaseHelper.instance.getAllArtistes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des Artistes'),
      ),
      body: FutureBuilder<List<Artistes>>(
        future: _Artistes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun artiste trouvé.'));
          }

          final Favoris = snapshot.data!;
          return ListView.builder(
            itemCount: Favoris.length,
            itemBuilder: (context, index) {
              final artiste = Favoris[index];
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
