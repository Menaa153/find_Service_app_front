import 'package:web_socket_channel/web_socket_channel.dart';

class ChatService {
  final String roomName;
  late WebSocketChannel channel;

  ChatService(this.roomName) {
    channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8000/ws/chat/$roomName/'));
  }

  void sendMessage(String sender, String message) {
    channel.sink.add('{"sender": "$sender", "message": "$message"}');
  }

  Stream get messages => channel.stream;
}
