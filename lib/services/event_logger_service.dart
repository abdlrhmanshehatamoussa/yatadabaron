import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply/simply.dart';
import 'package:yatadabaron/_modules/service_contracts.module.dart';

class EventLogger extends IEventLogger implements ISimpleService {
  EventLogger({
    required this.sharedPreferences,
    required this.versionInfoService,
  });

  final SharedPreferences sharedPreferences;
  final IVersionInfoService versionInfoService;
  final String sharedPrefKey = "cloudhub_events";

  @override
  Future<void> logAppStarted() async => await _logEvent(
        category: "system",
        description: "app_started",
      );

  @override
  Future<void> logTapEvent({
    required String description,
    Map<String, dynamic>? payload,
  }) async {
    await _logEvent(
      category: "ui_element_tap",
      description: description,
      payload: payload,
    );
  }

  @override
  Future<void> pushEvents() async {
    //TODO: Replace
    // List<String> actions = sharedPreferences.getStringList(sharedPrefKey) ?? [];
    // if (actions.isEmpty) return;
    // try {
    //   String payload = actions.join(",");
    //   payload = "[$payload]";
    //   Response response =
    //       await sdk.httpPATCH(endpoint: "events", payload: payload);

    //   if (response.statusCode == 204) {
    //     await sharedPreferences.setStringList(
    //       sharedPrefKey,
    //       [],
    //     );
    //   }
    // } catch (e) {
    //   return;
    // }
  }

  Future<void> _logEvent(
      {required String category,
      required String description,
      Map<String, dynamic>? payload}) async {
    DateTime createdOn = DateTime.now().toUtc();
    String? source; //TODO: Get serial key of the device
    Map<String, dynamic> actionMap = {};
    actionMap["description"] = description;
    actionMap["category"] = category;
    actionMap["build_id"] = versionInfoService.getBuildId();
    if (source != null) actionMap["source"] = source;
    if (payload != null) actionMap["payload"] = jsonEncode(payload);
    actionMap["created_on"] =
        createdOn.toIso8601String().replaceAll('T', ' ').replaceAll('Z', '');
    String actionJson = jsonEncode(actionMap);
    List<String> existingActions =
        sharedPreferences.getStringList(sharedPrefKey) ?? [];
    existingActions.add(actionJson);
    await sharedPreferences.setStringList(sharedPrefKey, existingActions);
  }
}
