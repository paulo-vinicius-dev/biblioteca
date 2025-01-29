import 'package:biblioteca/data/models/api_response_model.dart';
import 'package:biblioteca/data/services/api_service.dart';
import 'package:dio/dio.dart';

class RedefinirSenhaService {
  final String apiRoute = 'recuperarsenha';
  final ApiService _api = ApiService();

  Future<ApiResponse> enviarEmail(String email) async {
    final Map<String, dynamic> body = {"EmailDoUsuario": email};

    try {
      final response = await _api.requisicao(
        apiRoute,
        'POST',
        body,
      );
      return ApiResponse(
          responseCode: response.statusCode!, body: response.data);
    } on DioException {
      return ApiResponse(responseCode: 500, body: "Erro ao enviar email");
    }
  }

  Future<ApiResponse> redefinirSenha(String codigo, String novaSenha) async {
    final Map<String, dynamic> body = {
      "Codigo": codigo,
      "NovaSenha": novaSenha
    };

    final response = await _api.requisicao(
      apiRoute,
      'PUT',
      body,
    );

    return ApiResponse(responseCode: response.statusCode!, body: response.data);
  }
}
