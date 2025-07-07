import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';
import 'settings_service.dart';

class OpenAIService {
  Future<String> analyzeImage({
    required File image,
    String? additionalText,
  }) async {
    try {
      final apiKey = await SettingsService.getApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Chave da API não configurada');
      }

      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final String prompt =
          additionalText?.isEmpty ?? true
              ? AppConstants.defaultPrompt
              : '${AppConstants.defaultPrompt}\n\nContexto adicional: $additionalText';

      final response = await http.post(
        Uri.parse(AppConstants.openaiBaseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": AppConstants.gptModel,
          "messages": [
            {
              "role": "system",
              "content":
                  "Você é um assistente especializado em matemática que sempre responde em português brasileiro. Seja claro, detalhado e didático em suas explicações.",
            },
            {
              "role": "user",
              "content": [
                {"type": "text", "text": prompt},
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"},
                },
              ],
            },
          ],
          "max_tokens": AppConstants.maxTokens,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Erro na API: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao processar a imagem: $e');
    }
  }
}
