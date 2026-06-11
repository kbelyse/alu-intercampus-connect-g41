// Chat detail with message bubbles, reply, reactions, file messages, and input bar.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants.dart';
import '../../data/mock_data.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/message.dart';
import '../../widgets/common/avatar_circle.dart';

class ChatDetailScreen extends StatefulWidget {
  final String roomId;

  const ChatDetailScreen({super.key, required this.roomId});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  Message? _replyTo;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppDuration.normal,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(BuildContext context, String currentUserId, String currentUserName) {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatProvider>().sendMessage(
          widget.roomId,
          text,
          currentUserId,
          currentUserName,
          replyToId: _replyTo?.id,
          replyToContent: _replyTo?.content,
        );
    _inputController.clear();
    setState(() => _replyTo = null);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final chat = context.watch<ChatProvider>();
    final room = chat.getRoom(widget.roomId);
    final messages = chat.getMessages(widget.roomId);
    final userId = auth.user?.id ?? 'u1';
    final userName = auth.user?.name ?? 'Aline Umuhoza';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(LucideIcons.arrowLeft,
                color: AppColors.textPrimary, size: 20),
          ),
        ),
        title: Row(
          children: [
            AvatarCircle(
              initials: room?.name.substring(0, 2).toUpperCase() ?? 'CH',
              size: 36,
              color: room != null
                  ? Color(int.parse('FF${room.colorHex}', radix: 16))
                  : AppColors.primary,
              imageUrl: room?.avatarUrl,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room?.name ?? 'Chat',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${room?.memberCount ?? 0} members',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.video,
                color: AppColors.textPrimary, size: AppIconSize.standalone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical,
                color: AppColors.textPrimary, size: AppIconSize.standalone),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.md),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                final isMe = msg.senderId == userId;
                final showTime = i == 0 ||
                    messages[i].timestamp
                            .difference(messages[i - 1].timestamp)
                            .inMinutes >
                        15;
                return Column(
                  children: [
                    if (showTime)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md),
                        child: Text(
                          _formatGroupTime(msg.timestamp),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onLongPress: () =>
                          setState(() => _replyTo = msg),
                      child: _MessageBubble(
                        message: msg,
                        isMe: isMe,
                        senderAvatarUrl: mockUsers
                            .where((u) => u.id == msg.senderId)
                            .map((u) => u.avatarUrl)
                            .firstOrNull,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                );
              },
            ),
          ),

          // Reply banner
          if (_replyTo != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.elevated,
              child: Row(
                children: [
                  const Icon(LucideIcons.cornerUpLeft,
                      color: AppColors.primary, size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Replying to: ${_replyTo!.content}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _replyTo = null),
                    child: const Icon(LucideIcons.x,
                        color: AppColors.textSecondary, size: 16),
                  ),
                ],
              ),
            ),

          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm + MediaQuery.of(context).padding.bottom,
            ),
            color: AppColors.surface,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.smile,
                      color: AppColors.textSecondary,
                      size: AppIconSize.inline),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.elevated,
                      borderRadius: BorderRadius.circular(AppRadius.chip),
                    ),
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(
                          color: AppColors.textPrimary, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 12),
                        filled: false,
                        isDense: true,
                      ),
                      onSubmitted: (_) =>
                          _send(context, userId, userName),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.paperclip,
                      color: AppColors.textSecondary,
                      size: AppIconSize.inline),
                  onPressed: () {},
                ),
                GestureDetector(
                  onTap: () => _send(context, userId, userName),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(LucideIcons.send,
                        color: Colors.black, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatGroupTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inHours < 24) return DateFormat('h:mm a').format(dt);
    if (diff.inDays < 2) return 'Yesterday · ${DateFormat('h:mm a').format(dt)}';
    return DateFormat('MMM d · h:mm a').format(dt);
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;
  final String? senderAvatarUrl;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    this.senderAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding:
                    const EdgeInsets.only(left: AppSpacing.sm, bottom: 3),
                child: Row(
                  children: [
                    AvatarCircle(
                      initials: message.senderName.isNotEmpty
                          ? message.senderName.substring(0, 2).toUpperCase()
                          : '??',
                      size: 20,
                      fontSize: 8,
                      imageUrl: senderAvatarUrl,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      message.senderName,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // Reply quote
            if (message.replyToContent != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.neutralTag,
                  borderRadius:
                      BorderRadius.circular(AppRadius.card - 4),
                  border: const Border(
                    left: BorderSide(
                        color: AppColors.primary, width: 3),
                  ),
                ),
                child: Text(
                  message.replyToContent!,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

            // Main bubble
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: isMe
                    ? AppColors.sentBubble
                    : AppColors.elevated,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppRadius.card),
                  topRight: const Radius.circular(AppRadius.card),
                  bottomLeft: Radius.circular(
                      isMe ? AppRadius.card : 4),
                  bottomRight: Radius.circular(
                      isMe ? 4 : AppRadius.card),
                ),
                border: isMe
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3))
                    : null,
              ),
              child: message.type == MessageType.file
                  ? _FileBubble(message: message)
                  : Text(
                      message.content,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
            ),

            // Reactions
            if (message.reactions.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 4,
                  children: message.reactions.entries
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.neutralTag,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${e.key} ${e.value}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FileBubble extends StatelessWidget {
  final Message message;

  const _FileBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.fileText,
            color: AppColors.primary, size: 24),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.fileName ?? 'File',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (message.fileSize != null)
                Text(
                  message.fileSize!,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
            ],
          ),
        ),
        const Icon(LucideIcons.download,
            color: AppColors.primary, size: 18),
      ],
    );
  }
}
