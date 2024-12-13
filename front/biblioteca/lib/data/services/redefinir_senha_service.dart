import 'package:biblioteca/data/services/api_service.dart';

class RedefinirSenhaService {
  final String apiRoute = 'recuperarsenha';
  final ApiService _api = ApiService();

  Future<void> enviarEmail(String email) async {
    await _api.requisicao(
      apiRoute,
      'POST',
      {"EmailDoUsuario": email},
    );
  }

  Future<void> redefinirSenha(String codigo, String novaSenha) async {
    await _api.requisicao(
      apiRoute,
      'PUT',
      {"Codigo": codigo, "NovaSenha": novaSenha},
    );
  }
}
