import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/services/api_service.dart';

class UsuarioService extends ApiService {
  final String apiRoute = 'usuario';

  Future<UsuariosAtingidos> fetchUsuarios(
      num idDaSessao, String loginDoUsuarioRequerente) async {
    final response = await requisicao(
      apiRoute,
      'GET',
      {
        "IdDaSessao": idDaSessao,
        "LoginDoUsuarioRequerente": loginDoUsuarioRequerente,
        "TextoDeBusca": "_"
      },
    );

    if (response.statusCode != 200) {
      throw Exception();
    }
    return usuariosAtingidosFromJson(response.data);
  }
}
