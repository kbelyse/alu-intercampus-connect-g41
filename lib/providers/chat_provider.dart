// Manages chat rooms list and per-room message history.
import 'package:flutter/foundation.dart';
import '../models/chat_room.dart';
import '../models/message.dart';
import '../data/mock_data.dart';

class ChatProvider extends ChangeNotifier {
  final List<ChatRoom> _rooms = List.from(mockChatRooms);
  final Map<String, List<Message>> _messages = {
    for (final e in mockMessages.entries) e.key: List.from(e.value),
  };

  List<ChatRoom> get rooms => _rooms;

  ChatRoom? getRoom(String id) {
    try {
      return _rooms.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Message> getMessages(String roomId) =>
      _messages[roomId] ?? [];

  void sendMessage(String roomId, String content, String senderId,
      String senderName,
      {String? replyToId, String? replyToContent}) {
    final msg = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: DateTime.now(),
      replyToId: replyToId,
      replyToContent: replyToContent,
    );
    _messages.putIfAbsent(roomId, () => []);
    _messages[roomId]!.add(msg);
    notifyListeners();
  }

  void addReaction(String roomId, String messageId, String emoji) {
    final msgs = _messages[roomId];
    if (msgs == null) return;
    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;
    final current = Map<String, int>.from(msgs[idx].reactions);
    current[emoji] = (current[emoji] ?? 0) + 1;
    msgs[idx] = msgs[idx].copyWith(reactions: current);
    notifyListeners();
  }
}
