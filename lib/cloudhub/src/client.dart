class CloudHubClient {
  final String clientKey;
  final String clientSecret;
  final String apiUrl;
  final String appVersion;
  CloudHubClient({
    required this.clientKey,
    required this.clientSecret,
    required this.apiUrl,
    required this.appVersion,
  });
}