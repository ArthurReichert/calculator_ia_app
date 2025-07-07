import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class MessageInputWidget extends StatefulWidget {
  final Function(String text, File? image) onSendMessage;
  final bool isLoading;

  const MessageInputWidget({
    super.key,
    required this.onSendMessage,
    required this.isLoading,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startPulseIfNeeded();
  }

  void _startPulseIfNeeded() {
    if (_selectedImage == null && !widget.isLoading) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: AppConstants.imageQuality,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _startPulseIfNeeded();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: AppConstants.imageQuality,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _startPulseIfNeeded();
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar Imagem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();

    if (_selectedImage == null && text.isNotEmpty) {
      widget.onSendMessage(
        '',
        null,
      );
      return;
    }

    if (_selectedImage == null) {
      _showPhotoRequiredDialog();
      return;
    }

    widget.onSendMessage(text, _selectedImage);
    _textController.clear();
    setState(() {
      _selectedImage = null;
    });
    _startPulseIfNeeded();
  }

  void _showPhotoRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'Você deve fotografar seu cálculo',
                  style: AppTextStyles.subheading,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Adicione uma imagem com o problema matemático para que eu possa ajudá-lo a resolver.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
    _startPulseIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          if (_selectedImage != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadius,
                    ),
                    child: Image.file(
                      _selectedImage!,
                      height: AppConstants.inputImageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _removeImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _selectedImage == null ? _pulseAnimation.value : 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient:
                            _selectedImage == null
                                ? LinearGradient(
                                  colors: [
                                    AppColors.primary.withValues(alpha: 0.15),
                                    AppColors.primary.withValues(alpha: 0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        color:
                            _selectedImage != null
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : null,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              _selectedImage == null
                                  ? AppColors.primary.withValues(alpha: 0.4)
                                  : AppColors.primary.withValues(alpha: 0.5),
                          width: 2,
                        ),
                        boxShadow:
                            _selectedImage == null
                                ? [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                                : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap:
                              widget.isLoading ? null : _showImageSourceDialog,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    _selectedImage == null
                                        ? Icons.add_a_photo
                                        : Icons.check_circle,
                                    key: ValueKey(_selectedImage == null),
                                    color:
                                        _selectedImage == null
                                            ? AppColors.primary
                                            : AppColors.primary.withValues(
                                              alpha: 0.8,
                                            ),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedImage == null ? 'Foto' : 'OK',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        _selectedImage == null
                                            ? AppColors.primary
                                            : AppColors.primary.withValues(
                                              alpha: 0.8,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 120,
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Adicione contexto para sua imagem...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    maxLines: 4,
                    minLines: 1,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    enabled: !widget.isLoading,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  gradient:
                      _selectedImage != null
                          ? LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                          : null,
                  color: _selectedImage == null ? AppColors.background : null,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color:
                        _selectedImage == null
                            ? AppColors.textSecondary.withValues(alpha: 0.3)
                            : Colors.transparent,
                    width: 1,
                  ),
                  boxShadow:
                      _selectedImage != null
                          ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: widget.isLoading ? null : _sendMessage,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          widget.isLoading
                              ? Icons.hourglass_empty
                              : (_selectedImage == null
                                  ? Icons.close
                                  : Icons.send),
                          key: ValueKey(
                            '${widget.isLoading}_${_selectedImage != null}',
                          ),
                          color:
                              _selectedImage == null
                                  ? AppColors.textSecondary.withValues(
                                    alpha: 0.5,
                                  )
                                  : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
