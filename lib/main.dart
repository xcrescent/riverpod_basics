import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_state/examples/counter.dart';
import 'package:riverpod_state/examples/films.dart';
import 'package:riverpod_state/examples/names.dart';
import 'package:riverpod_state/examples/persons.dart';
import 'package:riverpod_state/examples/weather.dart';

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

// codeforces api
String key = 'b7f9363d897c61761b03592d7c9089c8d20a0b0c';
String secret = '12a4a57f5f6fda62fb92c053529be2841d1472c0';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      // home: const HomePage(),
      routes: {
        '/': (context) => const HomePage(),
        '/counter': (context) => const CounterPage(),
        '/name': (context) => const NamesPage(),
        '/persons': (context) => const PersonPage(),
        '/films': (context) => const FilmsPage(),
        '/weather': (context) => const WeatherPage(),
      },
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hoi'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/counter'),
              child: const Text('Counter Page'),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/name'),
              child: const Text('Name Page'),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/films'),
              child: const Text('Films Page'),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/weather'),
              child: const Text('Weather Page'),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed('/persons'),
              child: const Text('Persons Page'),
            ),
          ],
        ),
      ),
    );
  }
}
