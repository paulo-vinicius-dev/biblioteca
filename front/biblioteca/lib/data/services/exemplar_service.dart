import 'package:biblioteca/data/models/api_response_model.dart';
import 'package:biblioteca/data/models/exemplar_model.dart';
import 'package:biblioteca/data/services/api_service.dart';

class ExemplarService {
  final ApiService _api = ApiService();
  final String apiRoute = 'exemplar';

  // Retorna todos os exemplares
  Future<ApiResponse> fetchExemplares(int idLivro) async {
    List<Exemplar> exemplares = [];
    final Map<String, dynamic> body = {};

    final response = await _api.requisicao(
      '$apiRoute/livro/$idLivro',
      'GET',
      body,
    );

    if (response.statusCode == 200) {
      exemplares = List<Exemplar>.from(response.data.map((x) => Exemplar.fromJson(x)));
    }

    return ApiResponse(
      responseCode: response.statusCode!,
      body: response.statusCode == 200 ? exemplares : response.data,
    );
  }

  // Criar novo Exemplar
  Future<ApiResponse> addExemplar(Exemplar exemplar) async {
    final Map<String, dynamic> body = exemplar.toJson();

    final response = await _api.requisicao(
      apiRoute,
      'POST',
      body,
    );

    return ApiResponse(
      responseCode: response.statusCode!,
      body: response.data,
    );
  }

  // Alterar Exemplar
  Future<ApiResponse> alterExemplar(Exemplar exemplar) async {
    final Map<String, dynamic> body = exemplar.toJson();

    final response = await _api.requisicao(
      apiRoute,
      'PUT',
      body,
    );

    return ApiResponse(
      responseCode: response.statusCode!,
      body: response.data,
    );
  }

  // Deletar Exemplar
  Future<ApiResponse> deleteExemplar(int idExemplar) async {
    final Map<String, dynamic> body = {
      "idExemplar": idExemplar, // Usa o idExemplar como identificador
    };

    final response = await _api.requisicao(
      apiRoute,
      'DELETE',
      body,
    );

    return ApiResponse(
      responseCode: response.statusCode!,
      body: response.data,
    );
  }
}
