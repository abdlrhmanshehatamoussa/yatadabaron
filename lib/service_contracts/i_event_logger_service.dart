import 'package:simply/simply.dart';

abstract class IEventLogger extends SimpleService {
  Future<void> logTapEvent({
    required String description,
    Map<String, dynamic>? payload,
  });
  Future<void> logAppStarted();
  Future<void> pushEvents();
}
