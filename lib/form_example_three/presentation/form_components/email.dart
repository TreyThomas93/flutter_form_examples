import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/form_controller.dart';

class EmailComponent extends ConsumerStatefulWidget {
  const EmailComponent({super.key});

  @override
  ConsumerState<EmailComponent> createState() => _EmailComponentState();
}

class _EmailComponentState extends ConsumerState<EmailComponent> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(formController.select((value) => value.email),
        (_, state) {
      _emailController.text = state ?? '';
    });
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        hintText: 'Enter your email',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onChanged: (value) => ref.read(formController.notifier).email = value,
    );
  }
}
