import 'package:activity_management/views/calendar_view.dart';
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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

// class CalendarTry extends StatelessWidget {
//   final CalendarWeekController _controller = CalendarWeekController();
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             _controller.jumpToDate(DateTime.now());
//             print('sto loggando');
//           },
//           child: Icon(Icons.today),
//         ),
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.blue,
//           title: Text('Calendario'),
//         ),
//         body: Column(children: [
//           Container(
//               decoration: BoxDecoration(boxShadow: [
//                 BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 10,
//                     spreadRadius: 1)
//               ]),
//               child: CalendarWeek(
//                 controller: _controller,
//                 height: 150,
//                 showMonth: true,
//                 minDate: DateTime.now().add(
//                   Duration(days: -365),
//                 ),
//                 maxDate: DateTime.now().add(
//                   Duration(days: 365),
//                 ),
//                 onDatePressed: (DateTime datetime) {
//                   // Do something
//                   print(datetime);
//                 },
//                 onDateLongPressed: (DateTime datetime) {
//                   // Do something
//                 },
//                 onWeekChanged: () {
//                   // Do something
//                 },
//                 monthViewBuilder: (DateTime time) => Align(
//                   alignment: FractionalOffset.center,
//                   child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 4),
//                       child: Text(
//                         time.toString(),
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Colors.blue, fontWeight: FontWeight.w600),
//                       )),
//                 ),
//                 decorations: [
//                   DecorationItem(
//                       decorationAlignment: FractionalOffset.bottomRight,
//                       date: DateTime.now(),
//                       decoration: Icon(
//                         Icons.today,
//                         color: Colors.blue,
//                       )),
//                   DecorationItem(
//                       date: DateTime.now().add(Duration(days: 3)),
//                       decoration: Text(
//                         'Holiday',
//                         style: TextStyle(
//                           color: Colors.brown,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       )),
//                 ],
//               )),
//           Expanded(
//             child: Center(
//               child: Text(
//                 '${_controller.selectedDate.day}/${_controller.selectedDate.month}/${_controller.selectedDate.year}',
//                 style: TextStyle(fontSize: 30),
//               ),
//             ),
//           )
//         ]),
//       );
// }

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  var nowDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = CalendarView();
      default:
        throw UnimplementedError('No widget selected');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.calendar_month), label: Text('Calendar'))
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
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
          BigCard(pair: pair),
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
                  appState.getNext();
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

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      color: theme.colorScheme.primary,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }
    return ListView(
      children: [
        Text('va in figa di to mare: '),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          )
      ],
    );
  }
}
