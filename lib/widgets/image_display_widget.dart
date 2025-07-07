import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ImageDisplayWidget extends StatelessWidget {
  final File image;
  final VoidCallback? onRemove;

  const ImageDisplayWidget({super.key, required this.image, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.file(
              image,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            if (onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onRemove,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
