import 'package:biblioteca/data/models/login_model.dart';
import 'package:biblioteca/data/services/api_service.dart';

class AuthService extends ApiService {
  final String apiRoute = 'login';

  Future<Login> doLogin(String login, String senha) async {
    final response = await requisicao(
      apiRoute,
      'POST',
      {"Login": login, "Senha": senha},
    );

    return loginFromJson(response.data);
  }
}
