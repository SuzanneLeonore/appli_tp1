import 'package:flutter/material.dart';
import '/bdd_Init.dart';

class ArtistesPage extends StatefulWidget {
  const ArtistesPage({super.key});

  @override
  State<ArtistesPage> createState() => _ArtistesPageState();
}

class _ArtistesPageState extends State<ArtistesPage> {
  late Future<List<Map<String, dynamic>>> _artistes;

  @override
  void initState() {
    super.initState();
    _artistes = DatabaseHelper.instance.getAllProduits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des Produits'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _artistes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun produit trouvé.'));
          }

          final produits = snapshot.data!;
          return ListView.builder(
            itemCount: produits.length,
            itemBuilder: (context, index) {
              final produit = produits[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(produit['nom'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(produit['description']),
                  trailing: Text(
                    '${produit['prix'].toStringAsFixed(2)} €',
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
