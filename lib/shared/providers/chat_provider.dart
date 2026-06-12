import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_model.dart';
import '../../mock/mock_messages.dart';
import '../../core/constants/image_constants.dart';

class ChatRoomsNotifier extends StateNotifier<List<ChatRoomModel>> {
  ChatRoomsNotifier() : super(MockMessages.chatRooms);

  void markAsRead(String roomId) {
    state = state.map((r) {
      if (r.id == roomId) return r.copyWith(unreadCount: 0);
      return r;
    }).toList();
  }

  void updateLastMessage(String roomId, String message) {
    state = state.map((r) {
      if (r.id == roomId) {
        return r.copyWith(
          lastMessage: message,
          lastMessageTime: DateTime.now(),
          unreadCount: 0,
        );
      }
      return r;
    }).toList();
  }
}

final chatRoomsProvider = StateNotifierProvider<ChatRoomsNotifier, List<ChatRoomModel>>(
  (ref) => ChatRoomsNotifier(),
);

final totalUnreadMessagesProvider = Provider<int>((ref) {
  return ref.watch(chatRoomsProvider).fold(0, (sum, r) => sum + r.unreadCount);
});

class ChatMessagesNotifier extends StateNotifier<List<MessageModel>> {
  final String roomId;

  ChatMessagesNotifier(this.roomId)
      : super(MockMessages.chatMessages[roomId] ?? []);

  void sendMessage(String content) {
    final msg = MessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'user_001',
      senderName: 'Amara',
      senderAvatar: ImageConstants.currentUser,
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
    );
    state = [...state, msg];
  }
}

final chatMessagesProvider =
    StateNotifierProvider.family<ChatMessagesNotifier, List<MessageModel>, String>(
  (ref, roomId) => ChatMessagesNotifier(roomId),
);
