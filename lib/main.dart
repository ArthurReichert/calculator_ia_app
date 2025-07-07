import 'package:flutter/material.dart';
import 'screen/chat_page.dart';
import 'screen/api_setup_page.dart';
import 'services/settings_service.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora IA',
      theme: _buildTheme(),
      debugShowCheckedModeBanner: false,
      home: const AppInitializer(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.heading,
        headlineMedium: AppTextStyles.subheading,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    try {
      final hasApiKey = await SettingsService.hasApiKey();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) =>
                    hasApiKey ? const ChatPage() : const ApiSetupPage(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ApiSetupPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary),
            SizedBox(height: AppSpacing.lg),
            Text('Inicializando...', style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
