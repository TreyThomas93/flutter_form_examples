import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_four/presentation/controllers/form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_example_four/presentation/controllers/submit_form_controller.dart';
import 'form_example_four/presentation/example_four_screen.dart';
import 'form_example_one/presentation/example_one_screen.dart';
import 'form_example_three/presentation/example_three_screen.dart';
import 'form_example_two/presentation/example_two_screen.dart';
import 'provider_logger.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(ProviderScope(
    observers: [ProviderLogger()],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SubmitFormState?>(submitFormController, (__, state) {
      final context = navigatorKey.currentContext!;

      switch (state) {
        case Submitting(:final message):
          print(message);
          context.showLoadingCircle();
          break;
        case Success(:final message):
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
          ref.invalidate(formController);
          context.showSnackBar(message ?? 'Form submitted');
          break;
        case Error():
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
          context.showErrorSnackBar('Error submitting form');
          break;
        default:
          break;
      }
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const ExampleFourScreen(),
    );
  }
}
