import 'dart:convert';
import 'package:biblioteca/data/models/paises_resposta.dart';
import 'package:biblioteca/data/services/api_service.dart';

class PaisService {
  final ApiService _api = ApiService();
  final String apiRoute = 'pais';

  Future<PaisesAtingidos> fetchPaises(num idDaSessao, String loginUsuarioBuscador) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuario": loginUsuarioBuscador,
      "TextoDeBusca": "_"
    };

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode! >= 200 && response.statusCode! < 299) {
      print("Paises fetched: ${response.data}");
      final data = jsonDecode(response.data);
      print("Data dos paises fetched: $data");
      return PaisesAtingidos.fromJson(data);
    } else {
      print("Erro ao carregar os países: ${response.data}");
      throw Exception('Erro ao carregar os países: ${response.data}');
    }
  }
}
