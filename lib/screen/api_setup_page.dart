import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/settings_service.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import 'chat_page.dart';

class ApiSetupPage extends StatefulWidget {
  const ApiSetupPage({super.key});

  @override
  State<ApiSetupPage> createState() => _ApiSetupPageState();
}

class _ApiSetupPageState extends State<ApiSetupPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _checkExistingApiKey();
  }

  Future<void> _checkExistingApiKey() async {
    final apiKey = await SettingsService.getApiKey();
    if (apiKey != null && apiKey.isNotEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      }
    }
  }

  Future<void> _saveApiKey() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await SettingsService.saveApiKey(_apiKeyController.text.trim());

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar chave da API: $e'),
            backgroundColor: AppColors.error,
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
      return 'Por favor, insira sua chave da API';
    }

    final trimmed = value.trim();
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
          title: const Text('Como obter sua chave da API'),
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
                Text('5. Cole aqui no campo abaixo'),
                SizedBox(height: 16),
                Text(
                  'Nota: A chave deve começar com "sk-"',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(
                  const ClipboardData(
                    text: 'https://platform.openai.com/api-keys',
                  ),
                );
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link copiado para área de transferência'),
                  ),
                );
              },
              child: const Text('Copiar Link'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Ícone
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calculate,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Título
                    const Text(
                      'Calculadora IA',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Descrição
                    Text(
                      'Para usar o aplicativo, você precisa inserir sua chave da API OpenAI',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Formulário
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _apiKeyController,
                            decoration: InputDecoration(
                              labelText: 'Chave da API OpenAI',
                              hintText: 'sk-...',
                              prefixIcon: const Icon(Icons.key),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isObscured
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _isObscured = !_isObscured,
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.help_outline),
                                    onPressed: _showHelpDialog,
                                  ),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                            ),
                            obscureText: _isObscured,
                            validator: _validateApiKey,
                            maxLines: 1,
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Botão de salvar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveApiKey,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadius,
                                  ),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Text(
                                        'Salvar e Continuar',
                                        style: TextStyle(fontSize: 16),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Rodapé com informações de segurança
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.security,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sua chave é armazenada localmente no dispositivo de forma segura',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
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
