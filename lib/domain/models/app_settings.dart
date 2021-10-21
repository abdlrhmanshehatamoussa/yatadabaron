class AppSettings {
  final String cloudHubApiUrl;
  final String cloudHubClientKey;
  final String cloudHubClientSecret;
  final String cloudHubAppGuid;
  final String versionName;
  final String tafseerSourcesURL;
  final String tafseerTextURL;
  final int versionNumber;

  AppSettings({
    required this.cloudHubApiUrl,
    required this.cloudHubClientKey,
    required this.cloudHubClientSecret,
    required this.cloudHubAppGuid,
    required this.versionName,
    required this.tafseerSourcesURL,
    required this.tafseerTextURL,
    required this.versionNumber,
  });
}
