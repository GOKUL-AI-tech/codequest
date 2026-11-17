import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_theme.dart';
import '../../../data/models/notification_model.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';

// ─── PROVIDERS ────────────────────────────────────────────────────────────────

final chatStreamProvider =
    StreamProvider.family<List<ChatMessageModel>, String>((ref, roomId) {
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.chatStream(roomId).map((list) =>
      list.map((m) => m is ChatMessageModel ? m : m as ChatMessageModel).toList());
});

// ─── SCREEN ───────────────────────────────────────────────────────────────────

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  final String otherUsername;
  final String? otherAvatar;

  const ChatScreen({
    super.key,
    required this.roomId,
    required this.otherUsername,
    this.otherAvatar,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(target);
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;

    setState(() => _isSending = true);
    _controller.clear();

    try {
      final ds = ref.read(supabaseDatasourceProvider);
      await ds.sendMessage(
        roomId: widget.roomId,
        senderId: userId,
        content: text,
      );
      // Scroll after message appears
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send: $e'),
            backgroundColor: AppColors.neonPink,
          ),
        );
        _controller.text = text; // restore
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync =
        ref.watch(chatStreamProvider(widget.roomId));
    final currentUserId = ref.watch(currentUserProvider)?.id ?? '';

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Message list
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.neonCyan,
                ),
              ),
              error: (e, _) => Center(
                child: Text(
                  'Failed to load messages',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    color: context.cqTextMuted,
                  ),
                ),
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return _EmptyChatState(username: widget.otherUsername);
                }
                // Scroll to bottom whenever new messages arrive
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToBottom(animated: false);
                });
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == currentUserId;
                    final showAvatar = !isMe &&
                        (i == 0 || messages[i - 1].senderId != msg.senderId);
                    final showTimestamp = i == messages.length - 1 ||
                        messages[i + 1].senderId != msg.senderId;

                    return _MessageBubble(
                      message: msg,
                      isMe: isMe,
                      showAvatar: showAvatar,
                      showTimestamp: showTimestamp,
                      otherUsername: widget.otherUsername,
                      otherAvatar: widget.otherAvatar,
                    ).animate(delay: Duration(milliseconds: i * 20))
                        .fadeIn(duration: 200.ms);
                  },
                );
              },
            ),
          ),

          // ── Input bar
          _MessageInputBar(
            controller: _controller,
            isSending: _isSending,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: AppColors.neonCyan, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonCyan],
              ),
            ),
            child: widget.otherAvatar != null
                ? ClipOval(
                    child: Image.network(
                      widget.otherAvatar!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _AvatarFallback(
                        username: widget.otherUsername,
                      ),
                    ),
                  )
                : _AvatarFallback(username: widget.otherUsername),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.otherUsername,
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'online',
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 10,
                  color: AppColors.neonGreen,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: context.cqTextSecondary),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ─── MESSAGE BUBBLE ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;
  final bool showAvatar;
  final bool showTimestamp;
  final String otherUsername;
  final String? otherAvatar;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.showAvatar,
    required this.showTimestamp,
    required this.otherUsername,
    this.otherAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: showAvatar ? 8 : 2,
        bottom: showTimestamp ? 4 : 1,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Other's avatar
          if (!isMe)
            SizedBox(
              width: 32,
              child: showAvatar
                  ? Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.neonPurple,
                            AppColors.neonCyan,
                          ],
                        ),
                      ),
                      child: otherAvatar != null
                          ? ClipOval(
                              child: Image.network(
                                otherAvatar!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _AvatarFallback(
                                    username: otherUsername),
                              ),
                            )
                          : _AvatarFallback(username: otherUsername),
                    )
                  : null,
            ),

          if (!isMe) const SizedBox(width: 6),

          // Bubble
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.mediumImpact();
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Message copied'),
                    backgroundColor: context.cqCard,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: [
                            AppColors.neonCyan.withOpacity(0.85),
                            AppColors.neonPurple.withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMe ? null : context.cqCard,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  border: isMe
                      ? null
                      : Border.all(color: context.cqSurface, width: 1),
                  boxShadow: isMe
                      ? [
                          BoxShadow(
                            color: AppColors.neonCyan.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 14,
                        height: 1.4,
                        color: isMe
                            ? AppColors.bgDark
                            : context.cqTextPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (showTimestamp) ...[
                      const SizedBox(height: 3),
                      Text(
                        timeago.format(message.createdAt),
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 9,
                          color: isMe
                              ? AppColors.bgDark.withOpacity(0.6)
                              : context.cqTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          if (isMe) const SizedBox(width: 6),

          // My avatar placeholder (spacing only)
          if (isMe) const SizedBox(width: 32),
        ],
      ),
    );
  }
}

// ─── INPUT BAR ────────────────────────────────────────────────────────────────

class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;

  const _MessageInputBar({
    required this.controller,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cqBgSecondary,
        border: Border(
          top: BorderSide(color: context.cqSurface, width: 1),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 10
            : MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment button
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: context.cqTextMuted,
              size: 20,
            ),
            onPressed: () {},
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),

          const SizedBox(width: 6),

          // Text field
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: TextField(
                controller: controller,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 14,
                  color: context.cqTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: context.cqTextMuted,
                    fontFamily: 'Rajdhani',
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: context.cqCard,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.neonCyan.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isSending
                ? SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.neonCyan,
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onSend,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.neonCyan,
                            AppColors.neonPurple,
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonCyan.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── EMPTY CHAT STATE ─────────────────────────────────────────────────────────

class _EmptyChatState extends StatelessWidget {
  final String username;
  const _EmptyChatState({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonCyan],
              ),
            ),
            child: Center(
              child: Text(
                username.isNotEmpty ? username[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'Say hi to $username!',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.cqTextSecondary,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Start a conversation, share tips, or\nchallenge them to a coding battle!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              color: context.cqTextMuted,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HELPERS ─────────────────────────────────────────────────────────────────

class _AvatarFallback extends StatelessWidget {
  final String username;
  const _AvatarFallback({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
