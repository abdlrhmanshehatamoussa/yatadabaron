import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './users/module.dart';
import 'client.dart';
import 'constans.dart';

class CloudHubSDK {
  static CloudHubSDK? _instance;
  static CloudHubSDK get instance {
    if (_instance == null) {
      throw new Exception(
          "CloudHub SDK was called without being initialized !");
    }
    return _instance!;
  }

  static Future<void> initialize({
    required String clientKey,
    required String clientSecret,
    required String apiUrl,
    required String appVersion,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    CloudHubClient client = new CloudHubClient(
      clientKey: clientKey,
      clientSecret: clientSecret,
      apiUrl: apiUrl,
      appVersion: appVersion,
    );
    _instance = new CloudHubSDK._(clientInfo: client, preferences: pref);
  }

  //Class begins here
  CloudHubSDK._({required this.clientInfo, required this.preferences});
  final CloudHubClient clientInfo;
  final SharedPreferences preferences;

  Map<String, String> get _basicHeaders {
    return <String, String>{
      'client-key': this.clientInfo.clientKey,
      'client-claim':
          _encryptAES(this.clientInfo.clientKey, this.clientInfo.clientSecret)
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
      Uri.parse('${this.clientInfo.apiUrl}/$endpoint'),
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
      Uri.parse('${this.clientInfo.apiUrl}/$endpoint'),
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
      Uri.parse('${this.clientInfo.apiUrl}/$endpoint'),
      headers: headers,
    );
    return result;
  }

  Future<String> _generateNonce() async {
    Response result = await post(
      Uri.parse(
          '${this.clientInfo.apiUrl}/${CloudHubConstants.ENDPOINT_NONCE}'),
      headers: this._basicHeaders,
    );
    if (result.statusCode == 200) {
      dynamic nonceResponseObj = jsonDecode(result.body);
      String nonce = nonceResponseObj["token"];
      return _encryptAES(nonce, this.clientInfo.clientSecret);
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
      "login_type": CloudHubConstants.LOGINTYPE_GOOGLE,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await httpPOST(
      endpoint: CloudHubConstants.ENDPOINT_USER_LOGIN,
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
      "login_type": CloudHubConstants.LOGINTYPE_GOOGLE,
      "image_url": imageUrl,
      "name": name,
    };
    String payloadStr = jsonEncode(payload);
    Response response = await httpPOST(
      endpoint: CloudHubConstants.ENDPOINT_USER,
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
