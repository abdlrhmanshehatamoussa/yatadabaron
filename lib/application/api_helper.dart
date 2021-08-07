import 'dart:convert';
import 'package:http/http.dart';

class APIClientInfo {
  final String clientKey;
  final String clientSecret;
  final String applicationGUID;
  final String apiUrl;
  APIClientInfo({
    required this.clientKey,
    required this.clientSecret,
    required this.applicationGUID,
    required this.apiUrl,
  });
}

class APIHelper {
  //Fields
  final APIClientInfo _clientInfo;
  static const String ENDPOINT_NONCE = "nonce";
  static const String ENDPOINT_ACTIONS = "actions";

  //Private Constructor
  APIHelper(this._clientInfo);

  Map<String, String> get _basicHeaders {
    return <String, String>{
      'client-key': this._clientInfo.clientKey,
      'application-guid': this._clientInfo.applicationGUID
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
      String nonce = await this.generateNonce();
      headers['nonce'] = nonce;
    }
    Response result = await post(
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
      String nonce = await this.generateNonce();
      headers['nonce'] = nonce;
    }
    Response result = await get(
      Uri.parse('${this._clientInfo.apiUrl}/$endpoint'),
      headers: headers,
    );
    return result;
  }

  Future<String> generateNonce() async {
    Response result = await post(
      Uri.parse('${this._clientInfo.apiUrl}/$ENDPOINT_NONCE'),
      headers: this._basicHeaders,
    );
    if (result.statusCode == 200) {
      dynamic nonceResponseObj = jsonDecode(result.body);
      String nonce = nonceResponseObj["token"];
      return nonce;
    }
    throw new Exception("Failed to generate nonce");
  }
}
