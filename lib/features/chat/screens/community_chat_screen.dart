import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/providers/chat_provider.dart';
import '../../../shared/widgets/user_avatar.dart';

class CommunityChatScreen extends ConsumerStatefulWidget {
  final String roomId;

  const CommunityChatScreen({super.key, required this.roomId});

  @override
  ConsumerState<CommunityChatScreen> createState() =>
      _CommunityChatScreenState();
}

class _CommunityChatScreenState extends ConsumerState<CommunityChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(chatMessagesProvider(widget.roomId).notifier).sendMessage(text);
    ref.read(chatRoomsProvider.notifier).updateLastMessage(widget.roomId, text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(chatRoomsProvider);
    final messages = ref.watch(chatMessagesProvider(widget.roomId));
    dynamic room;
    try {
      room = rooms.firstWhere((r) => r.id == widget.roomId);
    } catch (_) {
      room = null;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
        title: room != null
            ? Row(
                children: [
                  UserAvatar(
                    imageUrl: room.avatarUrl,
                    name: room.name,
                    size: 36,
                    showOnlineIndicator: !room.isGroup,
                    isOnline: room.isOnline,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(room.name,
                          style: AppTypography.titleMedium),
                      Text(
                        room.isGroup
                            ? '${room.memberIds.length} members'
                            : room.isOnline
                                ? 'Online'
                                : 'Offline',
                        style: AppTypography.caption.copyWith(
                          color: room.isOnline && !room.isGroup
                              ? AppColors.success
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Text(widget.roomId, style: AppTypography.titleMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.elevated,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.more_vert,
                  color: AppColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('Start the conversation!',
                            style: AppTypography.headlineSmall),
                        Text('Be the first to say something',
                            style: AppTypography.bodyMedium),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, i) => _MessageBubble(
                      message: messages[i],
                    ).animate(delay: Duration(milliseconds: i * 20))
                        .fadeIn(duration: 200.ms),
                  ),
          ),

          // Input area
          Container(
            padding: EdgeInsets.fromLTRB(
                16, 10, 16, MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: AppColors.elevated,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      style: AppTypography.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Write a message...',
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe as bool;
    final time = DateFormat('h:mm a').format(message.timestamp as DateTime);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            UserAvatar(
              imageUrl: message.senderAvatar as String,
              name: message.senderName as String,
              size: 28,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe) ...[
                  Text(
                    message.senderName as String,
                    style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primary : AppColors.elevated,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  child: Text(
                    message.content as String,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isMe ? AppColors.background : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(time, style: AppTypography.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
