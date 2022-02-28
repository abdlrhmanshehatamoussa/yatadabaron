import 'dart:convert';
import '../constans.dart';
import '../sdk.dart';

class CloudHubAnalytics {
  static CloudHubAnalytics? _instance;
  static CloudHubAnalytics get instance =>
      _instance ?? new CloudHubAnalytics._(CloudHubSDK.instance);

  //Class begins here
  CloudHubAnalytics._(this.sdk);
  final CloudHubSDK sdk;

  Future<void> logAppStarted() async {
    await _logEvent(
      payload: "",
      category: "SYSTEM",
      description: "APP STARTED",
    );
  }

  Future<void> logOnTap(String desc, {String payload = ""}) async {
    await _logEvent(
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
    await _logEvent(
      payload: payload,
      category: "FORM FILLED",
      description: desc,
    );
  }

  Future<void> logError(
      {required String location, required String error}) async {
    await _logEvent(
      payload: error,
      category: "ERROR",
      description: location,
    );
  }

  Future<void> _logEvent({
    required String payload,
    required String category,
    required String description,
    DateTime? createdOn,
  }) async {
    createdOn = createdOn ?? DateTime.now();
    Map<String, dynamic> actionMap = new Map();
    int appVersion = int.tryParse(sdk.clientInfo.appVersion) ?? 0;
    actionMap["description"] = description;
    actionMap["category"] = category;
    actionMap["app_version"] = appVersion;
    actionMap["payload"] = payload;
    actionMap["created_on"] = createdOn.toString();
    String actionJson = jsonEncode(actionMap);
    List<String> existingActions = sdk.preferences
            .getStringList(CloudHubConstants.SHARED_PREF_KEY_EVENTS) ??
        [];
    existingActions.add(actionJson);
    await sdk.preferences.setStringList(
        CloudHubConstants.SHARED_PREF_KEY_EVENTS, existingActions);
  }

  Future<void> pushEvents() async {
    List<String> actions = sdk.preferences
            .getStringList(CloudHubConstants.SHARED_PREF_KEY_EVENTS) ??
        [];
    if (actions.length > 0) {
      try {
        String payload = actions.join(",");
        payload = "[$payload]";
        await sdk.httpPATCH(
          endpoint: "data/public/actions",
          payload: payload,
        );
        await sdk.preferences
            .setStringList(CloudHubConstants.SHARED_PREF_KEY_EVENTS, []);
      } catch (e) {}
    }
  }
}
