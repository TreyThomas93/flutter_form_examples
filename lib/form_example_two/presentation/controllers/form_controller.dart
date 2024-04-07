// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormModel {
  final String? email;
  late final DateTime date;

  FormModel({this.email, DateTime? date}) {
    this.date = date ?? DateTime.now();
  }
  FormModel copyWith({
    String? email,
    DateTime? date,
  }) {
    return FormModel(
      email: email ?? this.email,
      date: date ?? this.date,
    );
  }
}

final formController =
    NotifierProvider<FormController, FormModel>(() => FormController());

class FormController extends Notifier<FormModel> {
  @override
  FormModel build() => FormModel();

  set email(String email) {
    state = state.copyWith(email: email);
  }

  set date(DateTime date) {
    state = state.copyWith(date: date);
  }

  void reset() {
    state = FormModel();
  }

  Future<void> submit() async {
    print('Email: ${state.email}');
    print('Date: ${state.date}');
    print('sending to server...');
    await Future.delayed(const Duration(seconds: 2));
    print('Server response: success');
  }

  void update(FormModel Function(FormModel) form) {
    state = form(state);
  }
}
