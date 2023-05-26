abstract class WebSocketService {
  Future<bool> onConnect(String token);
  Future<bool> onDisconnect();
}
