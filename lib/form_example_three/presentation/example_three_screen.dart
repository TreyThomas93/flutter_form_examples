import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_three/presentation/controllers/submit_form_controller.dart';
import 'package:flutter_form_examples/form_example_three/presentation/form_components/date.dart';
import 'package:flutter_form_examples/form_example_three/presentation/form_components/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/form_controller.dart';

class ExampleThreeScreen extends ConsumerStatefulWidget {
  const ExampleThreeScreen({super.key});

  @override
  ConsumerState<ExampleThreeScreen> createState() => _ExampleOneScreenState();
}

class _ExampleOneScreenState extends ConsumerState<ExampleThreeScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(submitFormController.notifier)
          .submit(ref.read(formController));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubmitFormState?>(submitFormController, (__, state) {
      switch (state) {
        case Submitting():
          context.showLoadingCircle();
          break;
        case Success():
          context.pop();
          FocusManager.instance.primaryFocus?.unfocus();
          ref.invalidate(formController);
          context.showSnackBar('Form submitted');
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
