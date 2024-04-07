import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider_logger.dart';
import 'form_controller.dart';

// USING ASYNCVALUE
// final submitFormController =
//     AutoDisposeAsyncNotifierProvider<SubmitFormController, void>(
//         () => SubmitFormController());

// class SubmitFormController extends AutoDisposeAsyncNotifier<void> {
//   @override
//   AsyncValue? build() => const AsyncData(null);

//   Future<void> submit(FormModel formModel) async {
//     state = const AsyncLoading();
//     try {
//       await Future.delayed(const Duration(seconds: 2));
//       state = const AsyncData(null);
//     } catch (e, stackTrace) {
//       state = AsyncError(e, stackTrace);
//     }
//   }
// }

final submitFormController =
    AutoDisposeNotifierProvider<SubmitFormController, SubmitFormState?>(
        () => SubmitFormController());

class SubmitFormController extends AutoDisposeNotifier<SubmitFormState?> {
  @override
  SubmitFormState? build() => null;

  Future<void> submit(Future<void> Function() callBack,
      [String? submittingMessage, String? submittedMessage]) async {
    state = SubmitFormState.submitting(submittingMessage);
    try {
      await callBack();
      state = SubmitFormState.success(submittedMessage);
    } catch (e, stackTrace) {
      state = SubmitFormState.error(e, stackTrace);
    }
  }

  void submitSync(Function() callBack, [String? submittedMessage]) {
    state = const SubmitFormState.submitting();
    try {
      callBack();
      state = SubmitFormState.success(submittedMessage);
    } catch (e, stackTrace) {
      state = SubmitFormState.error(e, stackTrace);
    }
  }
}

// I typically do a sealed union for a controller state if I have more state options that I want to use. For this example, I could have just used an AsyncValue no problem.
sealed class SubmitFormState {
  const SubmitFormState();

  const factory SubmitFormState.submitting([String? message]) = Submitting;
  const factory SubmitFormState.success([String? message]) = Success;
  const factory SubmitFormState.error(Object error, StackTrace stackTrace) =
      Error;
}

class Submitting extends SubmitFormState {
  const Submitting([this.message]);

  final String? message;
}

class Success extends SubmitFormState {
  const Success([this.message]);

  final String? message;
}

class Error extends SubmitFormState implements ErrorBase {
  const Error(this.error, this.stackTrace);

  @override
  final Object error;
  @override
  final StackTrace stackTrace;
}
