import 'package:yatadabaron/simple/module.dart';

abstract class IAnalyticsService extends SimpleService<IAnalyticsService> {
  Future<void> logAppStarted();

  Future<void> logOnTap(String desc, {String payload = ""});

  Future<void> logFormFilled(String desc, {String payload = ""});

  Future<void> logError({required String location, required String error});

  Future<void> syncAllLogs();
}
