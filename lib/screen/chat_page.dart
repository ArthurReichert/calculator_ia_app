import 'dart:io';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/openai_service.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/loading_widget.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import 'change_api_key_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final OpenAIService _openAIService = OpenAIService();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildMessagesArea()),
            if (_isLoading) _buildLoadingArea(),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: const Icon(Icons.calculate, color: Colors.white, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Calculadora IA',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 150) {
                      return const Text(
                        'Resolva cálculos com IA',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (_messages.isNotEmpty)
          IconButton(
            onPressed: _clearChat,
            icon: const Icon(Icons.refresh),
            tooltip: 'Limpar conversa',
          ),
        PopupMenuButton<String>(
          onSelected: _handleMenuSelection,
          icon: const Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'change_api_key',
                child: Row(
                  children: [
                    Icon(Icons.key, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Expanded(child: Text('Trocar API Key')),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info, color: AppColors.textPrimary),
                    SizedBox(width: 8),
                    Expanded(child: Text('Sobre')),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildMessagesArea() {
    return _messages.isEmpty
        ? _buildEmptyState()
        : ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: _messages.length,
          itemBuilder: (context, index) {
            return ChatMessageWidget(message: _messages[index]);
          },
        );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.calculate,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Bem-vindo à Calculadora IA',
            style: AppTextStyles.heading,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Envie uma FOTO com cálculos matemáticos\ne nossa IA irá resolver para você!',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        'Tire uma foto do cálculo',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, color: AppColors.primary, size: 20),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        'Ou escolha da galeria',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildLoadingArea() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: const LoadingWidget(message: AppConstants.loadingMessage),
    );
  }

  Widget _buildInputArea() {
    return MessageInputWidget(
      onSendMessage: _handleSendMessage,
      isLoading: _isLoading,
    );
  }

  Future<void> _handleSendMessage(String text, File? image) async {
    if (image == null && text.isNotEmpty) {
      _showImageRequiredSnackBar();
      return;
    }

    if (image == null) return;

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.isEmpty ? AppConstants.emptyImageMessage : text,
      type: MessageType.user,
      image: image,
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _openAIService.analyzeImage(
        image: image,
        additionalText: text,
      );

      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        type: MessageType.ai,
      );

      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: AppConstants.errorMessage,
        type: MessageType.ai,
      );

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
      });

      _scrollToBottom();
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.scrollAnimationDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showImageRequiredSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.photo_camera, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            const Expanded(
              child: Text(
                'É necessário adicionar uma imagem com o cálculo!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'change_api_key':
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ChangeApiKeyPage()),
        );
        break;
      case 'about':
        _showAboutDialog();
        break;
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(child: Text('Sobre o App')),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calculadora IA',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Versão: 1.0.0',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),
              Text(
                'Um aplicativo que usa inteligência artificial para resolver problemas matemáticos através de imagens.',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              SizedBox(height: 16),
              Text(
                'Desenvolvido com Flutter pelo Arthur Reichert',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
