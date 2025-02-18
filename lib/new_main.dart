import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'pages/oeuvres_page.dart';
import 'pages/musees_page.dart';
import 'pages/artistes_page.dart';
import 'pages/favoris_page.dart';

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
        title: 'Art_log',
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
    OeuvrePage(),
    FavorisPage(),
    ArtistesPage(),
    MuseesPage(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Artistes", backgroundColor: Color.fromARGB(255, 2, 65, 116)),
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
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Artistes')),
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
                NavigationRailDestination(icon: Icon(Icons.home), label: Text('Artistes')),
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

class OeuvrePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accueil")),
      body: Center(child: Text('Page des oeuvres')),
    );
  }
}

class FavorisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoris")),
      body: Center(child: Text('Page des favoris')),
    );
  }
}

class ArtistesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Artistes")),
      body: Center(child: Text('Page des artistes')),
    );
  }
}

class MuseesPage extends StatelessWidget{

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Musées")),
      body: Center(child: Text('Page des Musées')),
    );
  }
}