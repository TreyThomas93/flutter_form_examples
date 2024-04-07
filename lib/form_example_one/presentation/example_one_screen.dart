import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_one/presentation/form_components/date.dart';
import 'package:flutter_form_examples/form_example_one/presentation/form_components/email.dart';

class ExampleOneScreen extends StatefulWidget {
  const ExampleOneScreen({super.key});

  @override
  State<ExampleOneScreen> createState() => _ExampleOneScreenState();
}

class _ExampleOneScreenState extends State<ExampleOneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController(text: DateTime.now().dateOnly);

  @override
  void dispose() {
    _emailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example One'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              EmailComponent(emailController: _emailController),
              DateComponent(dateController: _dateController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print(_emailController.text);
                    print(_dateController.text.toDateTime);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
