import 'package:biblioteca/data/models/api_response_model.dart';
import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/services/api_service.dart';
import 'package:biblioteca/data/models/exemplar_model.dart';

class LivroService {
  final ApiService _api = ApiService();
  final String apiRoute = 'livro';

  // Retorna todos os livros
  Future<ApiResponse> fetchLivros() async {
    List<Livro> livros = [];
    final Map<String, dynamic> body = {};

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode == 200) {
      livros = List<Livro>.from(response.data.map((x) => Livro.fromJson(x)));
    }

    return ApiResponse(
      responseCode: response.statusCode!,
      body: response.statusCode == 200 ? livros : response.data,
    );
  }

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


  // Criar novo Livro
  Future<ApiResponse> addLivro(Livro livro) async {
    final Map<String, dynamic> body = livro.toJson();

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

  // Alterar Livro
  Future<ApiResponse> alterLivro(Livro livro) async {
    final Map<String, dynamic> body = livro.toJson();

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

  // Deletar Livro
  Future<ApiResponse> deleteLivro(int id) async {
    final Map<String, dynamic> body = {
      "id": id,
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
