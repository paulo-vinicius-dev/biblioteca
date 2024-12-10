import 'package:biblioteca/data/models/login_model.dart';
import 'package:biblioteca/data/services/api_service.dart';

class AuthService {
  final String apiRoute = 'login';
  final ApiService _api = ApiService();

  Future<Login> doLogin(String login, String senha) async {
    final response = await _api.requisicao(
      apiRoute,
      'POST',
      {"Login": login, "Senha": senha},
    );

    return loginFromJson(response.data);
  }
}
