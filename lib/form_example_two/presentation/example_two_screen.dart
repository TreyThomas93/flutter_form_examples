import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_two/presentation/form_components/date.dart';
import 'package:flutter_form_examples/form_example_two/presentation/form_components/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/form_controller.dart';

class ExampleTwoScreen extends ConsumerStatefulWidget {
  const ExampleTwoScreen({super.key});

  @override
  ConsumerState<ExampleTwoScreen> createState() => _ExampleOneScreenState();
}

class _ExampleOneScreenState extends ConsumerState<ExampleTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        context.showLoadingCircle();
        await ref.read(formController.notifier).submit();
        if (mounted) {
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
          ref.read(formController.notifier).reset();
          context.showSnackBar('Form submitted');
        }
      } catch (e) {
        if (mounted) {
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
          context.showErrorSnackBar('Error submitting form');
        }
      }
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
