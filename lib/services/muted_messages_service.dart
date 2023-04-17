import 'package:shared_preferences/shared_preferences.dart';
import '../service_contracts/i_muted_messages_service.dart';

class MutedMessages extends IMutedMessagesService {
  final SharedPreferences sharedPreferences;

  MutedMessages({required this.sharedPreferences});

  @override
  Future<bool> isMuted(String messagedId) async {
    var isMuted = this.sharedPreferences.getBool(_id(messagedId));
    return isMuted ?? false;
  }

  @override
  Future<void> mute(messageId) async {
    await this.sharedPreferences.setBool(_id(messageId), true);
  }

  String _id(String id) {
    return "muted_$id";
  }
}
