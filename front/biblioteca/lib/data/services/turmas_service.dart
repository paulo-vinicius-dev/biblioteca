import 'dart:convert';

import 'package:biblioteca/data/models/turma.dart';
import 'package:biblioteca/data/services/api_service.dart';

class TurmasService {
  final String apiRoute = 'turmas';
  final ApiService _api = ApiService();

  //Retorna a lista de todas as turmas cadastradas no banco
  Future<List<Turma>> fetchTurmas() async {
    final response = await _api.requisicao(
      apiRoute,
      'GET',
      {},
    );
    Map<String, dynamic> turmas = json.decode(response.data);
    return List<Turma>.from(turmas["Turmas"].map((x) => Turma.fromJson(x)));
  }
}
