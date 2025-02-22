// lib/pages/musees_page.dart
import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/musee.dart';

class MuseesPage extends StatefulWidget {
  const MuseesPage({super.key});

  @override
  State<MuseesPage> createState() => _MuseesPageState();
}

class _MuseesPageState extends State<MuseesPage> {
  late Future<List<Musees>> _musees;

  @override
  void initState() {
    super.initState();
    _musees = DatabaseHelper.instance.getAllMusees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des musees'),
      ),
      body: FutureBuilder<List<Musees>>(
        future: _musees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun musee trouvé.'));
          }

          final musees = snapshot.data!;
          return ListView.builder(
            itemCount: musees.length,
            itemBuilder: (context, index) {
              final musee = musees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(musee.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(musee.description),
                  trailing: Text(
                    '${musee.prix.toStringAsFixed(2)} €',
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
