import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider_logger.dart';

final submitFormController =
    AutoDisposeNotifierProvider<SubmitFormController, SubmitFormState?>(
        () => SubmitFormController());

class SubmitFormController extends AutoDisposeNotifier<SubmitFormState?> {
  @override
  SubmitFormState? build() => null;

  void submit(Future<void> Function() cb) async {
    state = const SubmitFormState.submitting('Submitting form');
    try {
      await cb();
      state = const SubmitFormState.submitted('Form submitted');
    } catch (error, stackTrace) {
      state = SubmitFormState.error(error, stackTrace);
    }
  }

  void submitSync(Function() cb, [String? successMessage]) {
    state = const SubmitFormState.none();
    try {
      cb();
      state = SubmitFormState.submitted(successMessage ?? 'Form submitted');
    } catch (error, stackTrace) {
      state = SubmitFormState.error(error, stackTrace);
    }
  }
}

sealed class SubmitFormState {
  const SubmitFormState();

  const factory SubmitFormState.none() = None;
  const factory SubmitFormState.submitting([String? message]) = Submitting;
  const factory SubmitFormState.submitted([String? message]) = Submitted;
  const factory SubmitFormState.error(Object error, StackTrace stackTrace) =
      Error;
}

class None extends SubmitFormState {
  const None();
}

class Submitting extends SubmitFormState {
  final String? message;

  const Submitting([this.message]);
}

class Submitted extends SubmitFormState {
  final String? message;

  const Submitted([this.message]);
}

class Error extends SubmitFormState implements ErrorBase {
  @override
  final Object error;
  @override
  final StackTrace stackTrace;

  const Error(this.error, this.stackTrace);
}

extension SubmitFormStateX on SubmitFormState {
  T when<T>({
    required T Function() none,
    required T Function(String? message) submitting,
    required T Function(String? message) submitted,
    required T Function(Object error, StackTrace stackTrace) error,
  }) {
    final self = this;
    if (self is None) {
      return none();
    } else if (self is Submitting) {
      return submitting(self.message);
    } else if (self is Submitted) {
      return submitted(self.message);
    } else if (self is Error) {
      return error(self.error, self.stackTrace);
    } else {
      throw AssertionError();
    }
  }
}
