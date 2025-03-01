import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String roomId;
  final String sender;

  ChatScreen({required this.roomId, required this.sender});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final TextEditingController messageController = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse("ws://127.0.0.1:8000/ws/chat/${widget.roomId}/"));

    channel.stream.listen((message) {
      final decodedMessage = jsonDecode(message);
      setState(() {
        messages.add({
          "sender": decodedMessage["sender"],
          "message": decodedMessage["message"],
        });
      });
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      final messageData = jsonEncode({
        "sender": widget.sender,
        "message": messageController.text,
      });

      channel.sink.add(messageData);
      messageController.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat con el Prestador")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]["message"] ?? ""),
                  subtitle: Text("Enviado por: ${messages[index]["sender"]}"),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(labelText: "Escribe un mensaje..."),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


