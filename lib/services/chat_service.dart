import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatService {
  late WebSocketChannel channel;

  void connectToChat(String roomId) {
    channel = WebSocketChannel.connect(
      Uri.parse("ws://127.0.0.1:8000/ws/chat/cliente_prestador/"),
    );

    channel.stream.listen(
      (message) {
        print("Mensaje recibido: $message");
      },
      onError: (error) {
        print("Error en WebSocket: $error");
      },
      onDone: () {
        print("WebSocket cerrado.");
      },
    );
  }

  void sendMessage(String sender, String message) {
    channel.sink.add('{"sender": "$sender", "message": "$message"}');
  }

  void closeConnection() {
    channel.sink.close(status.goingAway);
  }
}


