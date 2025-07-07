import 'dart:io';
import '../utils/date_utils.dart';

enum MessageType { user, ai }

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final File? image;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    this.image,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? BrazilDateUtils.getBrazilTime();
}
