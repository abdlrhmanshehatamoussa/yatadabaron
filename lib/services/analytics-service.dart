import 'dart:convert';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_helper.dart';
import 'configurations-service.dart';

class AnalyticsService {
  AnalyticsService(this._pref, this._appVersion, this._apiHelper);

  static const String ACTIONS_SHARED_PREF_KEY = "ytdb_actions_json";
  static late AnalyticsService instance;

  final int _appVersion;
  final APIHelper _apiHelper;
  final SharedPreferences _pref;

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







  static Future<bool> initialize() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.buildNumber;
      int? versionInt = int.tryParse(version);
      APIHelper helper = APIHelper(
        new APIClientInfo(
          clientKey: ConfigurationService.instance.cloudHubClientKey,
          clientSecret: ConfigurationService.instance.cloudHubClientSecret,
          applicationGUID: ConfigurationService.instance.cloudHubAppGuid,
          apiUrl: ConfigurationService.instance.cloudHubApiUrl,
        ),
      );

      if (versionInt != null) {
        await SharedPreferences.getInstance();
        SharedPreferences pref = await SharedPreferences.getInstance();
        AnalyticsService.instance = AnalyticsService(pref, versionInt, helper);
        await AnalyticsService.instance.logAppStarted(push: true);
        return true;
      }
      return false;
    } catch (e) {
      print("Error while intiailizing analytics service: $e");
      return false;
    }
  }
}
