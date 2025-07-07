class AppConstants {
  //API Configuration
  static const String openaiBaseUrl =
      'https://api.openai.com/v1/chat/completions';
  static const String gptModel = 'gpt-4o';
  static const int maxTokens = 800;

  //Image Configuration
  static const int imageQuality = 80;
  static const double maxImageHeight = 250;
  static const double chatImageHeight = 150;
  static const double inputImageHeight = 120;

  //UI Configuration
  static const double borderRadius = 12;
  static const double messageBorderRadius = 16;
  static const double avatarRadius = 20;

  //Animation Configuration
  static const Duration scrollAnimationDuration = Duration(milliseconds: 300);

  //Messages
  static const String defaultPrompt =
      'Analise a imagem e resolva o cálculo matemático mostrado. Responda SEMPRE em português brasileiro, explicando o passo a passo da resolução de forma clara e detalhada.';
  static const String loadingMessage = 'Analisando sua imagem...';
  static const String errorMessage =
      'Desculpe, ocorreu um erro ao analisar a imagem. Tente novamente.';
  static const String emptyImageMessage = 'Analize este cálculo';
}
