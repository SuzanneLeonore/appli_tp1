import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/oeuvre.dart';

class OeuvrePage extends StatefulWidget {
  const OeuvrePage({super.key});

  @override
  State<OeuvrePage> createState() => _OeuvrePageState();
}

class _OeuvrePageState extends State<OeuvrePage> {
  late Future<List<Oeuvre>>  _oeuvres;

  @override
  void initState() {
    super.initState();
    _oeuvres = DatabaseHelper.instance.getAllOeuvres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des oeuvres'),
      ),
      body: FutureBuilder<List<Oeuvre>>(
        future: _oeuvres,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun oeuvre trouvé.'));
          }

          final oeuvres = snapshot.data!;
          return ListView.builder(
            itemCount: oeuvres.length,
            itemBuilder: (context, index) {
              final oeuvre = oeuvres[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(oeuvre.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(oeuvre.description),
                  trailing: Text(
                    '${oeuvre.prix.toStringAsFixed(2)} €',
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
