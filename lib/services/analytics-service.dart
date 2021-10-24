import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/api_helper.dart';
import 'interfaces/i_analytics_service.dart';

class AnalyticsService implements IAnalyticsService {
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
    List<String> actions = preferences.getStringList(ACTIONS_SHARED_PREF_KEY) ?? [];
    if (actions.length > 0) {
      try {
        String payload = actions.join(",");
        payload = "{\"actions\":[$payload]}";
        await this.apiHelper.httpPOST(
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