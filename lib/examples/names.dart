import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const names = ["Alice", "Bob", "Charlie", "Diana", "Eve"];
final tickerProvider = StreamProvider((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (x) => x + 1,
  );
});
final nameProvider = StreamProvider(
  (ref) =>
      ref.watch(tickerProvider.stream).map((event) => names.getRange(0, event)),
);


class NamesPage extends ConsumerWidget {
  const NamesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final names = ref.watch(nameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(children: [
         names.when(
        data: (names) => Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(names.elementAt(index)),
              );
            },
            itemCount: names.length,
          ),
        ),
        loading: () => const LinearProgressIndicator(),
        error: (err, stack) => Text(err.toString()),
      ),
      ],),
    );
  }
}