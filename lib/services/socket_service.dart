import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/chat.dart';

class SocketService {
  IO.Socket? socket;

  void connect(String userId, String ipaddress) {
    socket = IO.io('http://$ipaddress:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to Socket.IO server');
      // Emit an event to indicate that the user is online
      socket!.emit('user online', {'userId': userId});
    });

    // Listen for individual chat messages
    socket!.on('individual chat message', (data) {
      Message message = Message.fromJson(data);
      print(
          'Individual chat message received: Sender ID: ${message.senderId}, Content: ${message.content}');
    });

// Listen for team chat messages
    socket!.on('team chat message', (data) {
      Message message = Message.fromJson(data);
      print(
          'Team chat message received: Sender ID: ${message.senderId}, Content: ${message.content}');
    });

    socket!.onDisconnect((_) => print('Disconnected from Socket.IO server'));
  }

  void sendIndividualMessage(
      String senderId, String receiverId, String content) {
    socket!.emit('individual chat message', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
    });
    print('message emited');
  }

  void sendTeamMessage(String teamId, String senderId, String content) {
    socket!.emit('team chat message', {
      'teamId': teamId,
      'senderId': senderId,
      'content': content,
    });
  }

  void joinTeamChat(String teamId) {
    socket!.emit('join team chat', {'teamId': teamId});
  }

  void disconnect() {
    socket!.disconnect();
  }
}
