import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_example_one/presentation/example_one_screen.dart';
import 'form_example_three/presentation/example_three_screen.dart';
import 'form_example_two/presentation/example_two_screen.dart';
import 'provider_logger.dart';

void main() {
  runApp(ProviderScope(
    observers: [ProviderLogger()],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ExampleThreeScreen(),
    );
  }
}
