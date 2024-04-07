import 'package:flutter/material.dart';

class DateComponent extends StatelessWidget {
  const DateComponent({super.key, required this.dateController});

  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateController,
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
          dateController.text = dt.toString();
        }
      },
    );
  }
}
