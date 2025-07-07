import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';

class ChangeApiKeyPage extends StatefulWidget {
  const ChangeApiKeyPage({super.key});

  @override
  State<ChangeApiKeyPage> createState() => _ChangeApiKeyPageState();
}

class _ChangeApiKeyPageState extends State<ChangeApiKeyPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isObscured = true;
  String? _currentApiKey;

  @override
  void initState() {
    super.initState();
    _loadCurrentApiKey();
  }

  Future<void> _loadCurrentApiKey() async {
    final apiKey = await SettingsService.getApiKey();
    if (mounted) {
      setState(() {
        _currentApiKey = apiKey;
        if (apiKey != null && apiKey.isNotEmpty) {
          // Mostra apenas os primeiros e últimos caracteres para segurança
          final maskedKey =
              '${apiKey.substring(0, 7)}...${apiKey.substring(apiKey.length - 7)}';
          _apiKeyController.text = maskedKey;
        }
      });
    }
  }

  Future<void> _saveApiKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SettingsService.saveApiKey(_apiKeyController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Chave da API atualizada com sucesso!')),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar chave da API: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateApiKey(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira sua nova chave da API';
    }

    final trimmed = value.trim();

    // Se contém "..." é a versão mascarada, não validar
    if (trimmed.contains('...')) {
      return 'Por favor, insira uma nova chave da API';
    }

    if (!trimmed.startsWith('sk-')) {
      return 'Chave da API deve começar com "sk-"';
    }

    if (trimmed.length < 20) {
      return 'Chave da API muito curta';
    }

    return null;
  }

  void _showHelpDialog() {
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
              Icon(Icons.help_outline, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(child: Text('Como obter sua chave da API')),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '1. Acesse: https://platform.openai.com/api-keys',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('2. Faça login na sua conta OpenAI'),
                SizedBox(height: 8),
                Text('3. Clique em "Create new secret key"'),
                SizedBox(height: 8),
                Text('4. Copie a chave gerada'),
                SizedBox(height: 8),
                Text('5. Cole aqui no aplicativo'),
                SizedBox(height: 16),
                Text(
                  'Importante: A chave começa com "sk-" e é necessária para usar a IA.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendi'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Trocar Chave da API',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showHelpDialog,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Ajuda',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),

                // Ícone e título
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.key,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                const Text(
                  'Atualizar Chave da API',
                  style: AppTextStyles.heading,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Insira sua nova chave da API OpenAI para continuar usando a Calculadora IA.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),

                // Card com informação atual
                if (_currentApiKey != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Chave Atual',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Uma chave da API já está configurada.\nInsira uma nova para substituí-la.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Campo de entrada da API Key
                TextFormField(
                  controller: _apiKeyController,
                  validator: _validateApiKey,
                  obscureText: _isObscured,
                  enabled: !_isLoading,
                  onTap: () {
                    // Limpa o campo quando o usuário clica para editar
                    if (_apiKeyController.text.contains('...')) {
                      _apiKeyController.clear();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Nova Chave da API OpenAI',
                    hintText: 'sk-...',
                    prefixIcon: const Icon(Icons.key, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  maxLength: 200,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _saveApiKey(),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Botão de salvar
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveApiKey,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    elevation: 2,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'Atualizar Chave',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Botão de ajuda
                OutlinedButton.icon(
                  onPressed: _showHelpDialog,
                  icon: const Icon(
                    Icons.help_outline,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Como obter chave da API',
                    style: TextStyle(color: AppColors.primary),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }
}
