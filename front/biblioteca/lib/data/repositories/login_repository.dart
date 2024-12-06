import 'package:biblioteca/data/models/login_model.dart';
import 'package:biblioteca/data/services/login_service.dart';

class LoginRepository {
  final LoginService loginService;

  LoginRepository({required this.loginService});

  Future<Login> doLogin(String login, String senha) async {
    final response = await loginService.post(
      {"Login": login, "Senha": senha},
    );

    return loginFromJson(response.body);
  }
}
