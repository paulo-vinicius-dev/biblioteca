import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl;

  LoginService({required this.baseUrl});

  Future<http.Response> post(Map<String, dynamic> body) async {
    final url = Uri.http(baseUrl, '/login');

    return await http.post(url, body: jsonEncode(body));
  }
}
