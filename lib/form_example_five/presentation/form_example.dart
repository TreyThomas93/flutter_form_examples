// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:flutter_form_examples/extensions.dart';
import 'package:flutter_form_examples/form_example_five/presentation/controllers/submit_form_controller.dart';
import 'package:flutter_form_examples/form_example_five/presentation/providers/form_providers.dart';

class FormExample extends ConsumerStatefulWidget {
  const FormExample({super.key});

  @override
  ConsumerState<FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends ConsumerState<FormExample> {
  final _formKey = GlobalKey<FormBuilderState>();

  // key for service and patient
  final _serviceKey = GlobalKey<FormBuilderFieldState>();
  final _patientKey = GlobalKey<FormBuilderFieldState>();
  final _facilityKey = GlobalKey<FormBuilderFieldState>();

  String? get facility => _formKey.currentState?.fields['facility']?.value;
  Patient? get patient => _formKey.currentState?.fields['patient']?.value;
  bool get showAllPatients =>
      _formKey.currentState?.fields['show all patients']?.value ??
      _initialFormValues["show all patients"];
  Service? get service => _formKey.currentState?.fields['service']?.value;

  final _initialFormValues = <String, dynamic>{
    'facility': null,
    'patient': null,
    'show all patients': true,
    'service': null,
    'date': DateTime.now(),
    'start time': null,
    'end time': null,
  };

  @override
  Widget build(BuildContext context) {
    ref.listen(submitFormController, (previous, state) {
      state?.when(
        submitting: (message) {},
        none: () {},
        submitted: (message) {
          FocusManager.instance.primaryFocus?.unfocus();
          context.showSnackBar(message ?? 'Form submitted');
        },
        error: (error, stackTrace) {
          FocusManager.instance.primaryFocus?.unfocus();
          context.showErrorSnackBar('Error submitting form');
        },
      );
    });

    final facilities = ref.watch(facilityProvider(showAllPatients));
    final patients = ref.watch(patientProvider((showAllPatients, facility)));
    final services = ref.watch(serviceProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: FormBuilder(
            initialValue: _initialFormValues,
            key: _formKey,
            child: Column(
              children: [
                /// FACILITY
                FormBuilderDropdown(
                    key: _facilityKey,
                    name: 'facility',
                    decoration: const InputDecoration(labelText: 'Facility'),
                    items: [
                      for (final facility in facilities)
                        DropdownMenuItem(value: facility, child: Text(facility))
                    ],
                    onChanged: (value) => setState(() {}),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ])),
                const SizedBox(height: 20),
                // PATIENT
                FormBuilderDropdown(
                    key: _patientKey,
                    name: 'patient',
                    decoration: const InputDecoration(labelText: 'Patient'),
                    onChanged: (value) => setState(() {}),
                    items: [
                      for (final patient in patients)
                        DropdownMenuItem(
                            value: patient, child: Text(patient.name))
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ])),
                const SizedBox(height: 20),
                FormBuilderSwitch(
                    name: 'show all patients',
                    onChanged: (value) => setState(() {
                          _facilityKey.currentState?.reset();
                          _patientKey.currentState?.reset();
                        }),
                    title: const Text('Show All Patients')),
                const SizedBox(height: 20),
                if (facility != null && patient != null) ...[
                  // SERVICE
                  FormBuilderDropdown(
                    key: _serviceKey,
                    name: 'service',
                    onChanged: (value) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Service'),
                    items: [
                      for (final service in services)
                        DropdownMenuItem(
                            value: service, child: Text(service.name))
                    ],
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 20),
                ],
                // date picker
                FormBuilderDateTimePicker(
                  inputType: InputType.date,
                  name: 'date',
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  valueTransformer: (value) {
                    if (value is DateTime) {
                      return DateTime(value.year, value.month, value.day);
                    }
                    return value;
                  },
                ),
                const SizedBox(height: 20),
                // start time picker
                FormBuilderDateTimePicker(
                  inputType: InputType.time,
                  name: 'start time',
                  decoration: const InputDecoration(labelText: 'Start Time'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  valueTransformer: (value) {
                    if (value is DateTime) {
                      return TimeOfDay.fromDateTime(value);
                    }
                    return value;
                  },
                ),
                const SizedBox(height: 20),
                // end time picker
                FormBuilderDateTimePicker(
                  inputType: InputType.time,
                  name: 'end time',
                  decoration: const InputDecoration(labelText: 'End Time'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                  valueTransformer: (value) {
                    if (value is DateTime) {
                      return TimeOfDay.fromDateTime(value);
                    }
                    return value;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate and save the form values
                      // _formKey.currentState?.saveAndValidate();
                      // debugPrint(_formKey.currentState?.value.toString());
                      // FocusManager.instance.primaryFocus?.unfocus();

                      // On another side, can access all field values without saving form with instantValues
                      if (_formKey.currentState?.saveAndValidate() == false) {
                        return;
                      }

                      ref.read(submitFormController.notifier).submitSync(() {
                        final session = Session(
                          facility!,
                          patient!,
                          service!,
                          _formKey.currentState?.value['date'],
                          _formKey.currentState?.value['start time'],
                          _formKey.currentState?.value['end time'],
                        );
                        log(session.toString());
                      }, 'Session added');
                      return;

                      context.showLoadingCircle();
                      await Future.delayed(const Duration(seconds: 2));
                      if (context.mounted) {
                        context.showSnackBar('Form submitted');
                        context.pop();

                        _formKey.currentState?.reset();
                        _patientKey.currentState?.reset();
                        _serviceKey.currentState?.reset();
                      }
                    },
                    child: const Text('Add Session'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class Session {
  final String facility;
  final Patient patient;
  final Service service;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Session(this.facility, this.patient, this.service, this.date, this.startTime,
      this.endTime);

  @override
  String toString() {
    return 'Session(facility: $facility, patient: $patient, service: $service, date: $date, startTime: $startTime, endTime: $endTime)';
  }
}
