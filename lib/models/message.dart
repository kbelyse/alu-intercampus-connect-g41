// Message model for chat bubbles.
enum MessageType { text, file, system }

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final String? fileName;
  final String? fileSize;
  final Map<String, int> reactions;
  final String? replyToId;
  final String? replyToContent;

  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.fileName,
    this.fileSize,
    this.reactions = const {},
    this.replyToId,
    this.replyToContent,
  });

  Message copyWith({Map<String, int>? reactions}) => Message(
        id: id,
        senderId: senderId,
        senderName: senderName,
        content: content,
        timestamp: timestamp,
        type: type,
        fileName: fileName,
        fileSize: fileSize,
        reactions: reactions ?? this.reactions,
        replyToId: replyToId,
        replyToContent: replyToContent,
      );
}
