import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(249, 21, 0, 0.8)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  /* 
 * Qui aggiungo un array dove registro tutti i like
 * delle parole che sono state contrassegnare come preferita.
 * L'elenco può contenere solo coppie di parole.
 * Il generics, inoltre, così impostato garantisce pure che 
 * non ci siano tipi nulli inseriti per caso.
 */
  var favorites = <WordPair>[];

  //funzione per aggiungere o rimuovere una parola dai preferiti
  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
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

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pair),
            //aggiungo un separatore per dare più spazio ai pulsanti
            SizedBox(height: 10),
            //aggiungo il pulsante per passare alla parola successiva
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //pulsante per aggiungere like alla parola corrente
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),

                //do spazio tra i pulsanti
                SizedBox(width: 10),

                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
            //aggiungo un separatore per dare più spazio ai pulsanti
            SizedBox(height: 10),

            //versione suggerita da Codeium
            //aggiungo il pulsante per aggiungere o rimuovere una parola dai preferiti
            /*  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  child: Text('Like'),
                ),
              ],
            ), */
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
            //pair.asLowerCase, style: theme.textTheme.displayMedium
            pair.asLowerCase,
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

//VERSIONE CON LETTORE VOICEOVER CHE NON POSSO TESTARE PERCHÈ
//CREDO CHE IL MIO DISPOSITIVO SIA TROPPO LENTO
  /* Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Semantics(
          label: "${pair.first} ${pair.second}",
          child: Text(
            pair.asLowerCase,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  } */
}
