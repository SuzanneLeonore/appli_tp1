import 'package:flutter/material.dart';
import '/bdd_Init.dart';

class MuseesPage extends StatefulWidget {
  const MuseesPage({super.key});

  @override
  State<MuseesPage> createState() => _MuseesPageState();
}

class _MuseesPageState extends State<MuseesPage> {
  late Future<List<Map<String, dynamic>>> _musees;

  @override
  void initState() {
    super.initState();
    _musees = DatabaseHelper.instance.getAllProduits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des Produits'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _musees,
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
