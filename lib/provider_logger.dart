import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO FAIL-SAFE VS FAIL-FAST
class ProviderLogger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print(error.toString());
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    if (newValue is ErrorBase) {
      providerDidFail(provider, newValue.error, newValue.stackTrace, container);
    }
  }
}

class ErrorBase {
  final Object error;
  final StackTrace stackTrace;

  ErrorBase(this.error, this.stackTrace);
}
