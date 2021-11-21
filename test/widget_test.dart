import 'dart:convert';
import 'package:http/http.dart';
import 'package:yatadabaron/commons/api_helper.dart';
import 'package:yatadabaron/models/module.dart';

void main() async {
  CloudHubAPIHelper _apiHelper = CloudHubAPIHelper(
    CloudHubAPIClientInfo(
      apiUrl: "http://api.cloudhub.a1493d001.tech",
      applicationGUID: "b1f8e781-bb67-459e-b374-0f26b30a93f2",
      clientKey: "ce7c48fc-fcb2-4f0c-be20-2e88e94f380f",
      clientSecret: "6e0260c6-34be-4854-8608-2f9ebcb1084d",
    ),
  );

  try {
    Response response = await _apiHelper.httpGET(
      endpoint: CloudHubAPIHelper.ENDPOINT_RELEASES,
    );
    String body = response.body;
    List<dynamic> releasesJson = jsonDecode(body);
    List<ReleaseInfo> results =
        releasesJson.map((dynamic json) => ReleaseInfo.fromJson(json)).toList();
    print(results);
  } catch (e) {
    print(e);
  }
}
