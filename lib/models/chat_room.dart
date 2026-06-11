// ChatRoom model representing a group chat thread.
class ChatRoom {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int memberCount;
  final int unreadCount;
  final bool isActiveNow;
  final String colorHex;
  final String avatarUrl;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.memberCount,
    this.unreadCount = 0,
    this.isActiveNow = false,
    required this.colorHex,
    required this.avatarUrl,
  });
}
