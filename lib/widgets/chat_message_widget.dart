import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../utils/app_theme.dart';
import 'package:intl/intl.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;

    return Container(
      margin: EdgeInsets.only(
        bottom: AppSpacing.md,
        left: isUser ? 50 : 0,
        right: isUser ? 0 : 50,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isUser ? AppColors.userMessage : AppColors.aiMessage,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border:
                  isUser
                      ? null
                      : Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1,
                      ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUser ? Icons.person : Icons.smart_toy,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      isUser ? 'Você' : 'IA Calculator',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                if (message.image != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      message.image!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Text(message.text, style: AppTextStyles.body),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            DateFormat('HH:mm').format(message.timestamp),
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
