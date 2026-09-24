import 'dart:async';

/// Wraps a single-subscription source stream (e.g. `doc().snapshots()`) so
/// that repeated calls to a repository's `watchX()` method are cheap and
/// safe to share across independent widget lifecycles:
///
/// - The source is created and subscribed to only once, the first time
///   anything listens, and is never torn down after that — so navigating
///   away and back (which disposes the old `StreamBuilder` and creates a
///   new one) never tries to re-`listen()` an already-consumed
///   single-subscription stream, which would throw.
/// - Every new listener immediately receives the most recently emitted
///   value (if any), instead of waiting for the next Firestore change —
///   so reopening the same screen doesn't sit on a loading spinner forever
///   waiting for data that already arrived once.
/// - Multiple simultaneous listeners (e.g. the same tab rebuilding rapidly
///   during a scroll gesture) share one underlying subscription.
Stream<T> shareReplay<T>(Stream<T> Function() createSource) {
  T? lastValue;
  Object? lastError;
  StackTrace? lastStackTrace;
  var hasValue = false;
  StreamSubscription<T>? sourceSub;
  final controller = StreamController<T>.broadcast();

  void ensureSubscribed() {
    sourceSub ??= createSource().listen(
      (event) {
        lastValue = event;
        hasValue = true;
        lastError = null;
        controller.add(event);
      },
      onError: (Object error, StackTrace stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        controller.addError(error, stackTrace);
      },
    );
  }

  return Stream<T>.multi((listener) {
    ensureSubscribed();
    if (lastError != null) {
      listener.addError(lastError!, lastStackTrace);
    } else if (hasValue) {
      listener.add(lastValue as T);
    }
    final sub = controller.stream.listen(listener.add, onError: listener.addError);
    listener.onCancel = () => sub.cancel();
  }, isBroadcast: true);
}
