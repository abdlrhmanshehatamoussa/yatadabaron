import 'package:http/http.dart';
import '../sdk.dart';

class CloudHubPublicData {
  static CloudHubPublicData? _instance;
  static CloudHubPublicData get instance =>
      _instance ?? new CloudHubPublicData._(CloudHubSDK.instance);

  //Class begins here
  CloudHubPublicData._(this.sdk);
  final CloudHubSDK sdk;

  Future<Response> getPublicData(String collectionName) async {
    return await sdk.httpGET(endpoint: "data/public/$collectionName");
  }
}
