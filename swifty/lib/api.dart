import 'package:http/http.dart' as http;
import 'dart:convert';

class Api42 {
  static String? _accessToken;

  static Future<void> authenticate() async {
    const String uid = String.fromEnvironment('API_UID');
    const String secret = String.fromEnvironment('API_SECRET');

    final response = await http.post(
      Uri.parse('https://api.intra.42.fr/oauth/token'),
      body: {
        'grant_type': 'client_credentials',
        'client_id': uid,
        'client_secret': secret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];
    } else {
      throw Exception('Authentification échouée : ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getUser(String login) async {
    if (_accessToken == null) await authenticate();

    final response = await http.get(
      Uri.parse('https://api.intra.42.fr/v2/users/$login'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur : ${response.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers({int page = 1}) async {
  if (_accessToken == null) await authenticate();

  final response = await http.get(
    Uri.parse('https://api.intra.42.fr/v2/campus/lyon/users?page=$page&per_page=40&filter[kind]=student&sort=login'),
    headers: {'Authorization': 'Bearer $_accessToken'},
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.cast<Map<String, dynamic>>();
  }
  throw Exception('Erreur : ${response.statusCode}');
}
}