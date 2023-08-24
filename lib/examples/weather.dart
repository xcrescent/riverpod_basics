

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  amsterdam,
  rotterdam,
  utrecht,
}

Future<String> getWeather(City city) {
  return Future.delayed(
    const Duration(milliseconds: 600),
    () =>
        {
          City.amsterdam: 'sunny',
          City.rotterdam: "rainy",
          City.utrecht: "cloudy"
        }[city] ??
        'sunny',
  );
}
// UI writes to this

final currentCityProvider = StateProvider<City?>((ref) => null);
// UI reads from this
final weatherProvider = FutureProvider((ref) {
  final city = ref.watch(currentCityProvider);
  return getWeather(city ?? City.amsterdam);
});

class WeatherPage extends ConsumerWidget {
  const WeatherPage({super.key});
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      currentWeather.when(
        data: (weather) => Text(
          weather,
          style: const TextStyle(fontSize: 40),
        ),
        loading: () => const LinearProgressIndicator(),
        error: (err, stack) => Text(err.toString()),
      ),
      Expanded(
          child: ListView.builder(
        itemBuilder: (context, index) {
          final city = City.values[index];
          return ListTile(
            title: Text(city.toString()),
            onTap: () {
              ref.read(currentCityProvider.notifier).state = city;
            },
            trailing: city == ref.watch(currentCityProvider)
                ? const Icon(Icons.check)
                : null,
          );
        },
        itemCount: City.values.length,
      )),
      
        ],
      ),
    );
  }
}