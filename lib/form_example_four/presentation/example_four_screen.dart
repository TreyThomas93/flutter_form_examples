import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_four/presentation/controllers/submit_form_controller.dart';
import 'package:flutter_form_examples/form_example_four/presentation/form_components/date.dart';
import 'package:flutter_form_examples/form_example_four/presentation/form_components/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/form_controller.dart';

class ExampleFourScreen extends ConsumerStatefulWidget {
  const ExampleFourScreen({super.key});

  @override
  ConsumerState<ExampleFourScreen> createState() => _ExampleOneScreenState();
}

class _ExampleOneScreenState extends ConsumerState<ExampleFourScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      ref.read(formController.notifier).submit();
      // ref.read(formController.notifier).submitSync();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Two'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              OutlinedButton(
                  onPressed: () {
                    ref.invalidate(formController);
                  },
                  child: const Text('Reset Form')),
              const EmailComponent(),
              const DateComponent(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
