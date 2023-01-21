import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class EventLogger extends IEventLogger {
  @override
  Future<void> logAppStarted() async =>
      await FirebaseAnalytics.instance.logAppOpen();

  @override
  Future<void> logTapEvent({
    required String description,
    Map<String, dynamic>? payload,
  }) async {
    await FirebaseAnalytics.instance.logEvent(
      name: description,
      parameters: payload,
    );
  }
}
