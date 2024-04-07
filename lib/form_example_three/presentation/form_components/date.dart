import 'package:flutter/material.dart';
import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_three/presentation/controllers/form_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateComponent extends ConsumerStatefulWidget {
  const DateComponent({super.key});

  @override
  ConsumerState<DateComponent> createState() => _DateComponentState();
}

class _DateComponentState extends ConsumerState<DateComponent> {
  late final TextEditingController _dateController;

  @override
  void initState() {
    _dateController =
        TextEditingController(text: ref.read(formController).date.dateOnly);
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<DateTime>(formController.select((value) => value.date),
        (_, state) {
      _dateController.text = state.dateOnly;
    });
    return TextFormField(
      controller: _dateController,
      decoration: const InputDecoration(
        labelText: 'Date',
      ),
      readOnly: true,
      onTap: () async {
        final dt = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
        );

        if (dt != null) {
          _dateController.text = dt.dateOnly;
          ref.read(formController.notifier).date = dt;
        }
      },
    );
  }
}
