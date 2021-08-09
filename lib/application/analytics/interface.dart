abstract class IAnalyticsService {
  Future<void> logAppStarted({bool push = false});

  Future<void> logOnTap(String desc, {String payload = "", bool push = false});

  Future<void> logFormFilled(String desc,
      {String payload = "", bool push = false});
}
