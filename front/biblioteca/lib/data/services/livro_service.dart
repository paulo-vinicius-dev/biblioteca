import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/services/api_service.dart';
import 'package:biblioteca/data/models/livros_resposta.dart';


class LivroService {
  final ApiService _api = ApiService();
  final String apiRoute = 'livro';

  // Retorna todos os livros como um objeto LivrosAtingidos
  Future<LivrosAtingidos> fetchLivros(num idDaSessao, String loginDoUsuarioRequerente) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuario": loginDoUsuarioRequerente,
    };

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode == 200) {
      return LivrosAtingidos.fromJson(response.data); // Retorna a resposta como LivrosAtingidos
    } else {
      throw Exception('Erro ao carregar os livros: ${response.data}');
    }
  }

    Future<LivrosAtingidos> searchExemplares(num idDaSessao,
      String loginDoUsuarioRequerente, String textoDeBusca) async {
    final Map<String, dynamic> body = {
      "IdDaSessao": idDaSessao,
      "LoginDoUsuario": loginDoUsuarioRequerente,
    };

    final response = await _api.requisicao(
      apiRoute,
      'GET',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
    return livrosAtingidosFromJson(response.data);
  }


  // Criar novo Livro
  Future<void> addLivro(Livro livro) async {
    final Map<String, dynamic> body = livro.toJson();

    final response = await _api.requisicao(
      apiRoute,
      'POST',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao adicionar livro: ${response.data}');
    }
  }

  // Alterar Livro
  Future<void> alterLivro(Livro livro) async {
    final Map<String, dynamic> body = livro.toJson();

    final response = await _api.requisicao(
      apiRoute,
      'PUT',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao alterar livro: ${response.data}');
    }
  }

  // Deletar Livro
  Future<void> deleteLivro(int id) async {
    final Map<String, dynamic> body = {
      "id": id,
    };

    final response = await _api.requisicao(
      apiRoute,
      'DELETE',
      body,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar livro: ${response.data}');
    }
  }
}
