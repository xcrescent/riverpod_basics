


import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavourite,
  });
  Film copy({required bool isFavourite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavourite: isFavourite,
      );
  @override
  String toString() =>
      'Film(id: $id, title: $title, description: $description, isFavourite: $isFavourite)';

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavourite == other.isFavourite;

  @override
  int get hashCode => Object.hashAll([
        id,
        isFavourite,
      ]);
}

const allFilms = [
  Film(
      id: '1',
      title: 'The Shawshank Redemption',
      description: 'Description for The Shawshank Redemption',
      isFavourite: false),
  Film(
      id: '2',
      title: 'The Godfather',
      description: 'Description for The Godfather',
      isFavourite: false),
  Film(
      id: '3',
      title: 'The Godfather: Part II',
      description: 'Description for The Godfather: Part II',
      isFavourite: false),
  Film(
      id: '4',
      title: 'The Dark Knight',
      description: 'Description for The Dark Knight',
      isFavourite: false),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void toggleFavourite(String id) {
    state = state.map((film) {
      if (film.id == id) {
        return film.copy(isFavourite: !film.isFavourite);
      }
      return film;
    }).toList();
  }
}

enum Filter { all, favourites, notFavourites }

final filterProvider = StateProvider<Filter>((_) => Filter.all);
final filmsProvider =
    StateNotifierProvider<FilmsNotifier, List<Film>>((_) => FilmsNotifier());
final favouriteFilmsProvider = Provider<List<Film>>((ref) {
  final filter = ref.watch(filterProvider);
  final films = ref.watch(filmsProvider);
  switch (filter) {
    case Filter.all:
      return films;
    case Filter.favourites:
      return films.where((film) => film.isFavourite).toList();
    case Filter.notFavourites:
      return films.where((film) => !film.isFavourite).toList();
  }
});

class FilmsPage extends ConsumerWidget {
  const FilmsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FilterWidget(),
          Consumer(
            builder: (context, ref, child) {
              return FilmsWidget(provider: favouriteFilmsProvider);
            },
          ),
        ],
      ),
    );
  }
}

class FilmsWidget extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmsWidget({required this.provider, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final film = films.elementAt(index);
          return ListTile(
            title: Text(film.title),
            subtitle: Text(film.description),
            // onTap: () {
            //   ref.read(filterProvider.notifier).state = film;
            // },
            trailing: IconButton(
              onPressed: () =>
                  ref.read(filmsProvider.notifier).toggleFavourite(film.id),
              icon: film.isFavourite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
          );
        },
        itemCount: films.length,
      ),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final filter = ref.watch(filterProvider);
        return DropdownButton<Filter>(
          value: filter,
          onChanged: (Filter? value) {
            ref.read(filterProvider.notifier).state = value!;
          },
          items: Filter.values
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.toString().split('.').last),
                  ))
              .toList(),
        );
      },
    );
  }
}
