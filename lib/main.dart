import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphQL_config.dart';

void main() {
  final client = GraphQLConfig.initClient();
  runApp(
    GraphQLProvider(
      client: client,  // ✅ Corrige ici
      child: MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.initClient(), 
      child: ChangeNotifierProvider(
        create: (context) => MyAppState(), 
        child: MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 1, 49, 97)),
          ),
          home: MyHomePage(), // il faut que PeintresPage() soit bien utilisée où nécessaire
        ),
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
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                  
                  
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
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
  final String query = """
    query {
      getPeintres {
        id
        nom
        nationalite
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des Peintres")),
      body: Query(
        options: QueryOptions(document: gql(query)),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (result.hasException) {
            return Center(child: Text("Erreur: ${result.exception.toString()}"));
          }

          // Récupérer la liste des peintres
          List peintres = result.data?["getPeintres"] ?? [];

          return ListView.builder(
            itemCount: peintres.length,
            itemBuilder: (context, index) {
              var peintre = peintres[index];
              return ListTile(
                title: Text(peintre["nom"]),
                subtitle: Text(peintre["nationalite"]),
              );
            },
          );
        },
      ),
    );
  }
}
class MuseumsPage extends StatelessWidget{
   @override
  Widget build(BuildContext context) {
    return Scaffold();
    
  }
}