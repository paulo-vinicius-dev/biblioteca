import 'dart:convert';

import 'package:biblioteca/utils/config.dart';
import 'package:dio/dio.dart';


class ApiService {
  final Dio _dio = Dio();
  final Map<String, String> _headers = {'Content-Type': 'application/json'};

  Future<Response> requisicao(String route, String method, Map<String, dynamic> body) async {
  final String url = "${AppConfig.baseUrl}/$route";
    return await _dio.request(
      url,
      options: Options(
        method: method,
        headers: _headers,
      ),
      data: jsonEncode(body),
    );
  }
}
