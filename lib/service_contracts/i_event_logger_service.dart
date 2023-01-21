abstract class IEventLogger {
  Future<void> logTapEvent({
    required String description,
    Map<String, dynamic>? payload,
  });
  Future<void> logAppStarted();
}
