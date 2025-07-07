import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({super.key, this.message = 'Analisando imagem...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SpinKitWave(color: AppColors.primary, size: 50.0),
          const SizedBox(height: AppSpacing.md),
          Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
