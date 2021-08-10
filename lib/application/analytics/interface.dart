abstract class IAnalyticsService {
  Future<void> logAppStarted();

  Future<void> logOnTap(String desc, {String payload = ""});

  Future<void> logFormFilled(String desc,
      {String payload = ""});

  Future<void> syncAllLogs();
}
