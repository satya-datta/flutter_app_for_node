class Config {
  static const String developmentBaseUrl = 'http://192.168.0.153:3000';
  static const String productionBaseUrl =
      'https://node3-flutter-server.onrender.com';

  static const bool isProduction = true; // Change this to true for production

  static String get baseUrl {
    return isProduction ? productionBaseUrl : developmentBaseUrl;
  }
}
