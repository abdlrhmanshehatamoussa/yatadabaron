enum CloudHubLoginStatus {
  SUCCESS,
  ERROR,
  NOT_REGISTERED,
  ALREADY_LOGGED_IN
}

enum CloudHubRegisterStatus {
  SUCCESS,
  ERROR,
  ALREADY_REGISTERED,
}

class CloudHubLoginResult {
  final CloudHubLoginStatus status;
  final Map<String, dynamic>? result;

  CloudHubLoginResult(this.status, this.result);
}

class CloudHubRegisterResult {
  final CloudHubRegisterStatus status;
  final Map<String, dynamic>? result;

  CloudHubRegisterResult(this.status, this.result);
}
