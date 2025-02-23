import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'pages/oeuvres_page.dart';
import 'pages/favoris_page.dart';
import 'pages/artistes_page.dart';
import 'pages/musees_page.dart';
import 'package:appli_tp1/bdd_Init.dart';

void main() async {
  print("App démarrée");
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp( const MyApp() );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
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
        home: HomePage(),
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

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage>createState() =>_HomePageState();
}

class _HomePageState extends State<HomePage>{
  late Future<void> _initDatabaseFuture;
  var selectedIndex = 0; 
  

  final List<Widget> pages = [
    OeuvrePage(),
    FavorisPage(),
    ArtistesPage(),
    MuseesPage(),
  ];

  @override
  void initState() {
    super.initState();
    _initDatabaseFuture = DatabaseHelper.instance.init();
  }


  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initDatabaseFuture,  
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Art_Logue")),
            body: Center(child: CircularProgressIndicator()),  // Attente de la DB
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Art_Logue")),
            body: Center(child: Text('Erreur : ${snapshot.error}')),
          );
        } else {
          return ScreenTypeLayout(
            mobile: smallScreenLayout(),
            tablet: largeScreenLayout(context),
            desktop: largeScreenLayout(context),
          );
        }
      },
    );
  }


  Widget smallScreenLayout() {
    return Scaffold(
      appBar: AppBar(title: Text("Art_Logue")),
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

  Widget largeScreenLayout(context) {
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

  Widget desktopLayout(context) {
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