import 'package:http/http.dart' as http;

class UserService {
  final baseUrl = Uri.http('localhost:9090', '/usuario');

  Future<String> buscarUsuario(int idDaSessao, String loginDoUsuarioRequerente,
      String textoDeBusca) async {

    var response = await http.post(baseUrl, );
    return response.body;
  }
}

void main() {
  final userService = UserService();
  print(userService.buscarUsuario(6186548912227058333, 'admin', 'a'));
}
