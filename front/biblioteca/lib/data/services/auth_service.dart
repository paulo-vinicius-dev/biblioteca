import 'dart:convert';

import 'package:biblioteca/data/models/login_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  Future<http.Response> _post(Map<String, dynamic> body) async {
    final url = Uri.http(baseUrl, '/login');

    return await http.post(url, body: jsonEncode(body));
  }


  Future<Login> doLogin(String login, String senha) async {
    final response = await _post(
      {"Login": login, "Senha": senha},
    );

    return loginFromJson(response.body);
  }
}
