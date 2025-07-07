import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _apiKeyKey = 'openai_api_key';
  static const String _isFirstLaunchKey = 'is_first_launch';

  static Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
    await prefs.setBool(_isFirstLaunchKey, false);
  }

  static Future<String?> getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_apiKeyKey);
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  static Future<void> clearApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyKey);
    await prefs.setBool(_isFirstLaunchKey, true);
  }

  static Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }
}
