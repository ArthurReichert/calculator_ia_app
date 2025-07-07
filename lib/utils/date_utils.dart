class BrazilDateUtils {
  /// Retorna o horário atual no timezone do Brasil (UTC-3)
  static DateTime getBrazilTime() {
    final now = DateTime.now().toUtc();
    return now.subtract(const Duration(hours: 3));
  }

  /// Converte um DateTime para o timezone do Brasil
  static DateTime toBrazilTime(DateTime dateTime) {
    final utc = dateTime.toUtc();
    return utc.subtract(const Duration(hours: 3));
  }
}
