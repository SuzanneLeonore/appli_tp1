import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 1, 45, 116)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}


class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  //à modifier pour les format Json rçu
  var favorites = <WordPair>[];
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}




class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // Déclare selectedIndex au niveau de la classe
  

  final List<Widget> pages = [
    GeneratorPage(),
    FavoritesPage(),
    PainterPage(),
    MuseumsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: smallScreenLayout(),
      tablet: largeScreenLayout(),
      desktop: largeScreenLayout(),
    );
  }

  Widget smallScreenLayout() {
    return Scaffold(
      appBar: AppBar(title: Text("Stateful Bottom Bar")),
      body: pages[selectedIndex], // Affiche la page sélectionnée
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index; // Met à jour l'index sélectionné
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.brush), label: "Accueil", backgroundColor: Color.fromARGB(255, 2, 65, 116)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris", backgroundColor: Color.fromARGB(255, 2, 65, 116)),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Peintres", backgroundColor: Color.fromARGB(255, 2, 65, 116)),
          BottomNavigationBarItem(icon: Icon(Icons.museum), label: "Musées", backgroundColor: Color.fromARGB(255, 2, 65, 116)),
        ],
      ),
    );
  }

  Widget largeScreenLayout() {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex, // Utilise le même index
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.brush), label: Text('Accueil')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favoris')),
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Peintres')),
                NavigationRailDestination(icon: Icon(Icons.museum), label: Text('Musées')),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: pages[selectedIndex], // Correction ici, on affiche la bonne page
            ),
          ),
        ],
      ),
    );
  }

  Widget desktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              selectedIndex: selectedIndex, // Utilise le même index
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              destinations: [
                NavigationRailDestination(icon: Icon(Icons.brush), label: Text('Accueil')),
                NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favoris')),
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Peintres')),
                NavigationRailDestination(icon: Icon(Icons.museum), label: Text('Musées')),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: pages[selectedIndex], // Correction ici, on affiche la bonne page
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {

  List artworks = [];
   Future<void> fetchArtworks() async {
    final response = await http.get(Uri.parse('http://localhost:8080'));
    if (response.statusCode == 200) {
      setState(() {
        artworks = jsonDecode(response.body);
      });
    } else {
      throw Exception('Échec du chargement des œuvres');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Art Collections')),
      body: ListView.builder(
        itemCount: artworks.length,
        itemBuilder: (context, index) {
          var art = artworks[index];
          return ListTile(
            leading: Image.network(
              art['image_url'] ?? 'https://via.placeholder.com/150',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(art['title']),
            subtitle: Text('${art['artist']} (${art['year'] ?? 'Inconnu'})'),
          );
        },
      ),
    );
  }
}


// class des 4 pages

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}

class PainterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
class MuseumsPage extends StatelessWidget{

 @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}