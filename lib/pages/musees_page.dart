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

  @override
  void initState() {
    super.initState();
    _musees = _loadMusee();
  }

  Future<List<Musee>> _loadMusee() async {
    final musees = await DatabaseHelper.instance.getMusees();
    for (var musee in musees) {
      await musee.loadFavoriteState();  
    }
    return musees;
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
                margin: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    musee.logo.isNotEmpty
                        ? Image.network(musee.logo, width: 100, height: 100, fit: BoxFit.cover)
                        : Icon(Icons.image_not_supported, size: 100),  
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(musee.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Date de création: ${musee.dateCreation}'),
                            Text('Adresse: ${musee.adresse}'),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        musee.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: musee.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          musee.isFavorite = !musee.isFavorite; 
                          musee.saveFavoriteState();
                        });
                      },
                    ),
                  ]
                ),
              );
            },
          );
        },
      ),
    );
  }
  List<Musee> getFavorites(List<Musee> musee) {
    return musee.where((musee) => musee.isFavorite).toList();
  }
}
