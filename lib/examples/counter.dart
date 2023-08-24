import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Counter extends StateNotifier<int> {
  Counter() : super(0);
  void increment() => state++;
}

final counterProvider = StateNotifierProvider((ref) => Counter());

class CounterPage extends ConsumerWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (builder, ref, child) {
          return Text('Counter: $count');
        }),
      ),
      body: Center(
          child: TextButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        child: const Text('Increment'),
      )),
    );
  }
}
