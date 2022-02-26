import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yatadabaron/simple/_module.dart';
import 'package:yatadabaron/commons/api_helper.dart';

abstract class IAnalyticsService {
  Future<void> logAppStarted();

  Future<void> logOnTap(String desc, {String payload = ""});

  Future<void> logFormFilled(String desc, {String payload = ""});

  Future<void> logError({required String location, required String error});

  Future<void> syncAllLogs();
}

class AnalyticsService implements IAnalyticsService, ISimpleService {
  AnalyticsService({
    required this.preferences,
    required this.appVersion,
    required this.apiHelper,
  });

  static const String ACTIONS_SHARED_PREF_KEY = "ytdb_actions_json";

  final int appVersion;
  final CloudHubAPIHelper apiHelper;
  final SharedPreferences preferences;

  @override
  Future<void> logAppStarted() async {
    await _logAction(
      appVersion: this.appVersion,
      payload: "",
      category: "SYSTEM",
      description: "APP STARTED",
    );
  }

  @override
  Future<void> logOnTap(String desc, {String payload = ""}) async {
    await _logAction(
      appVersion: this.appVersion,
      payload: payload,
      category: "UI ELEMENT TAP",
      description: desc,
    );
  }

  Future<void> logFormFilled(
    String desc, {
    String payload = "",
    bool push = false,
  }) async {
    await _logAction(
      appVersion: this.appVersion,
      payload: payload,
      category: "FORM FILLED",
      description: desc,
    );
  }

  @override
  Future<void> syncAllLogs() async {
    List<String> actions =
        preferences.getStringList(ACTIONS_SHARED_PREF_KEY) ?? [];
    if (actions.length > 0) {
      try {
        String payload = actions.join(",");
        payload = "[$payload]";
        await this.apiHelper.httpPATCH(
              endpoint: CloudHubAPIHelper.ENDPOINT_ACTIONS,
              payload: payload,
            );
        await preferences.setStringList(ACTIONS_SHARED_PREF_KEY, []);
      } catch (e) {}
    }
  }

  @override
  Future<void> logError(
      {required String location, required String error}) async {
    await _logAction(
      appVersion: this.appVersion,
      payload: error,
      category: "ERROR",
      description: location,
    );
  }

  Future<void> _logAction({
    required int appVersion,
    required String payload,
    required String category,
    required String description,
    DateTime? createdOn,
  }) async {
    createdOn = createdOn ?? DateTime.now();
    Map<String, dynamic> actionMap = new Map();
    actionMap["description"] = description;
    actionMap["category"] = category;
    actionMap["app_version"] = appVersion;
    actionMap["payload"] = payload;
    actionMap["created_on"] = createdOn.toString();
    String actionJson = jsonEncode(actionMap);
    List<String> existingActions =
        preferences.getStringList(ACTIONS_SHARED_PREF_KEY) ?? [];
    existingActions.add(actionJson);
    await preferences.setStringList(ACTIONS_SHARED_PREF_KEY, existingActions);
  }
}
