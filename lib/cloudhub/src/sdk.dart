import 'dart:convert';
import 'package:http/http.dart';
import './users/module.dart';

class CloudHubClient {
  final String clientKey;
  final String clientSecret;
  final String apiUrl;
  CloudHubClient({
    required this.clientKey,
    required this.clientSecret,
    required this.apiUrl,
  });
}

class CloudHubSDK {
  //Private Constructor
  CloudHubSDK(this._clientInfo);

  //Singleton
  static void Initialize({
    required String clientKey,
    required String clientSecret,
  }) {}

  //Fields
  final CloudHubClient _clientInfo;

  static const String ENDPOINT_NONCE = "nonce";
  static const String ENDPOINT_ACTIONS = "data/public/actions";
  static const String ENDPOINT_RELEASES = "data/public/releases";
  static const String _ENDPOINT_USER = "users";
  static const String _ENDPOINT_USER_LOGIN = "users/login";
  static const String ENDPOINT_TAFSEER_SOURCES = "data/public/tafseer_sources";
  static const int _LOGINTYPE_GOOGLE = 1932278;

  Map<String, String> get _basicHeaders {
    return <String, String>{
      'client-key': this._clientInfo.clientKey,
      'client-claim':
          _encryptAES(this._clientInfo.clientKey, this._clientInfo.clientSecret)
    };
  }

  Future<Response> httpPOST({
    required String endpoint,
    required String payload,
    bool generateNonce = true,
    Map<String, String>? headers,
  }) async {
    if (headers == null) {
      headers = this._basicHeaders;
    }
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (generateNonce) {
      String nonce = await this._generateNonce();
      headers['nonce'] = nonce;
    }
    Response result = await post(
      Uri.parse('${this._clientInfo.apiUrl}/$endpoint'),
      headers: headers,
      body: payload,
    );
    return result;
  }

  Future<Response> httpPATCH({
    required String endpoint,
    required String payload,
    bool generateNonce = true,
    Map<String, String>? headers,
  }) async {
    if (headers == null) {
      headers = this._basicHeaders;
    }
    headers['Content-Type'] = 'application/json; charset=UTF-8';
    if (generateNonce) {
      String nonce = await this._generateNonce();
      headers['nonce'] = nonce;
    }
    Response result = await patch(
      Uri.parse('${this._clientInfo.apiUrl}/$endpoint'),
      headers: headers,
      body: payload,
    );
    return result;
  }

  Future<Response> httpGET({
    required String endpoint,
    Map<String, String>? headers,
    bool generateNonce = true,
  }) async {
    if (headers == null) {
      headers = this._basicHeaders;
    }
    if (generateNonce) {
      String nonce = await this._generateNonce();
      headers['nonce'] = nonce;
    }
    Response result = await get(
      Uri.parse('${this._clientInfo.apiUrl}/$endpoint'),
      headers: headers,
    );
    return result;
  }

  Future<String> _generateNonce() async {
    Response result = await post(
      Uri.parse('${this._clientInfo.apiUrl}/$ENDPOINT_NONCE'),
      headers: this._basicHeaders,
    );
    if (result.statusCode == 200) {
      dynamic nonceResponseObj = jsonDecode(result.body);
      String nonce = nonceResponseObj["token"];
      return _encryptAES(nonce, this._clientInfo.clientSecret);
    }
    throw new Exception("Failed to generate nonce");
  }

  Future<CloudHubLoginResult> loginGoogle({
    required String email,
    required String token,
  }) async {
    //TODO: Validate input parameters
    dynamic payload = {
      "email": email,
      "password": token,
      "login_type": CloudHubSDK._LOGINTYPE_GOOGLE,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await httpPOST(
      endpoint: CloudHubSDK._ENDPOINT_USER_LOGIN,
      payload: payloadStr,
    );
    switch (response.statusCode) {
      case 200:
        return CloudHubLoginResult(
          CloudHubLoginStatus.SUCCESS,
          jsonDecode(response.body),
        );
      case 495:
        return CloudHubLoginResult(
          CloudHubLoginStatus.NOT_REGISTERED,
          null,
        );
      default:
        return CloudHubLoginResult(
          CloudHubLoginStatus.ERROR,
          null,
        );
    }
  }

  Future<CloudHubRegisterResult> registerGoogle({
    required String email,
    required String token,
    required String name,
    required String? imageUrl,
  }) async {
    //TODO: Validate input parameters
    dynamic payload = {
      "email": email,
      "password": token,
      "login_type": CloudHubSDK._LOGINTYPE_GOOGLE,
      "image_url": imageUrl,
      "name": name,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await httpPOST(
      endpoint: CloudHubSDK._ENDPOINT_USER,
      payload: payloadStr,
    );
    switch (response.statusCode) {
      case 200:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.SUCCESS,
          jsonDecode(response.body),
        );
      case 494:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.ALREADY_REGISTERED,
          null,
        );
      default:
        return CloudHubRegisterResult(
          CloudHubRegisterStatus.ERROR,
          null,
        );
    }
  }

  String _encryptAES(String text, String encryptionKey) {
    return text + "|" + encryptionKey;
  }
}
