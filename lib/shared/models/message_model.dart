class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String content;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
  });
}

enum MessageType { text, image, link }

class ChatRoomModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isGroup;
  final bool isOnline;
  final List<String> memberIds;

  const ChatRoomModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.isGroup,
    this.isOnline = false,
    this.memberIds = const [],
  });

  ChatRoomModel copyWith({int? unreadCount, String? lastMessage, DateTime? lastMessageTime}) {
    return ChatRoomModel(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup,
      isOnline: isOnline,
      memberIds: memberIds,
    );
  }
}
