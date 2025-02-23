import 'package:flutter/material.dart';
import '/bdd_Init.dart';
import '/Type_donnee/musee.dart';

class MuseesPage extends StatefulWidget {
  const MuseesPage({super.key});

  @override
  State<MuseesPage> createState() => _MuseesPageState();
}

class _MuseesPageState extends State<MuseesPage> {
  late Future<List<Musee>> _musees;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _musees = _databaseHelper.getMusees(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue des musées'),
      ),
      body: FutureBuilder<List<Musee>>(
        future: _musees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun musée trouvé.'));
          }

          final musees = snapshot.data!;
          return ListView.builder(
            itemCount: musees.length,
            itemBuilder: (context, index) {
              final musee = musees[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(musee.logo), 
                    radius: 30,
                  ),
                  title: Text(musee.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date de création : ${musee.dateCreation}', 
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Adresse : ${musee.adresse}', 
                        style: const TextStyle(fontSize: 14),
                      ),
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
