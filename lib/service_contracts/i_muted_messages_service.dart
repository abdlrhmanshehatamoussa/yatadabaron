abstract class IMutedMessagesService {
  Future<bool> isMuted(String messagedId);
  Future<void> mute(String messageId);
}
