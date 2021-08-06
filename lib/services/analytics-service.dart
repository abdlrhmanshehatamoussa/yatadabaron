import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_helper.dart';

class AnalyticsService {
  AnalyticsService(this._appVersion, this._apiHelper);

  static const String ACTIONS_SHARED_PREF_KEY = "ytdb_actions_json";
  static late AnalyticsService instance;

  final int _appVersion;
  final APIHelper _apiHelper;

  Future<void> logAppStarted({bool push = false}) async {
    await _logAction(
      appVersion: this._appVersion,
      payload: "",
      category: "SYSTEM",
      description: "APP STARTED",
      push: push,
    );
  }

  Future<void> logOnTap(
    String desc, {
    String payload = "",
    bool push = false,
  }) async {
    await _logAction(
      appVersion: this._appVersion,
      payload: payload,
      category: "UI ELEMENT TAP",
      description: desc,
      push: push,
    );
  }

  Future<void> logFormFilled(
    String desc, {
    String payload = "",
    bool push = false,
  }) async {
    await _logAction(
      appVersion: this._appVersion,
      payload: payload,
      category: "FORM FILLED",
      description: desc,
      push: push,
    );
  }

  Future<void> _logAction({
    required int appVersion,
    required String payload,
    required String category,
    required String description,
    DateTime? createdOn,
    bool push = false,
  }) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    createdOn = createdOn ?? DateTime.now();
    Map<String, dynamic> actionMap = new Map();
    actionMap["description"] = description;
    actionMap["category"] = category;
    actionMap["app_version"] = appVersion;
    actionMap["payload"] = payload;
    actionMap["created_on"] = createdOn.toString();
    String actionJson = jsonEncode(actionMap);
    List<String> existingActions =
        _pref.getStringList(ACTIONS_SHARED_PREF_KEY) ?? [];
    existingActions.add(actionJson);
    await _pref.setStringList(ACTIONS_SHARED_PREF_KEY, existingActions);
    if (push) {
      this._pushEvents();
    }
  }

  Future<void> _pushEvents() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    List<String> actions = _pref.getStringList(ACTIONS_SHARED_PREF_KEY) ?? [];
    if (actions.length > 0) {
      try {
        String payload = actions.join(",");
        payload = "{\"actions\":[$payload]}";
        await this._apiHelper.httpPOST(
              endpoint: APIHelper.ENDPOINT_ACTIONS,
              payload: payload,
            );
        await _pref.setStringList(ACTIONS_SHARED_PREF_KEY, []);
      } catch (e) {
        print("Error occurred while synchronizing actions: ${e.toString()}");
      }
    } else {
      print("No actions found to be synchronized.");
    }
  }
}
