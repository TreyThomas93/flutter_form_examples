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

  void update(FormModel Function(FormModel) form) {
    state = form(state);
  }
}
