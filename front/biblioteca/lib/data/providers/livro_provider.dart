import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/services/livro_service.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/data/models/exemplar_model.dart';


class LivroProvider extends ChangeNotifier {
  final LivroService _livroService = LivroService();
  bool _isLoading = false;
  String? _error;
  List<Livro> _livros = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasErrors => _error != null;
  List<Livro> get livros => [..._livros];

  // Carregar todos os livros
  Future<void> loadLivros() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _livroService.fetchLivros();
        print('API Response Code: ${apiResponse.responseCode}');
        print('API Response Body: ${apiResponse.body}');

      if (apiResponse.responseCode == 200) {
        _livros = apiResponse.body;
      } else {
        _error = apiResponse.body;
      }
    } catch (e) {
      _error = "Erro ao carregar os Livros:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Exemplar>> loadExemplares(int idLivro) async {
    try {
      final apiResponse = await _livroService.fetchExemplares(idLivro);
      if (apiResponse.responseCode == 200) {
        return apiResponse.body; // Retorna a lista de exemplares
      } else {
        throw Exception('Erro ao carregar exemplares');
      }
    } catch (e) {
      throw Exception('Erro ao carregar exemplares: $e');
    }
  }

  // Adicionar um novo livro
  Future<void> addLivro(Livro livro) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _livroService.addLivro(livro);

      if (apiResponse.responseCode > 299) {
        _error = apiResponse.body;
      } else {
        _livros.add(livro);
      }
    } catch (e) {
      _error = "Erro ao inserir novo Livro:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Editar um livro existente
  Future<void> editLivro(Livro livro) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _livroService.alterLivro(livro);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        // Atualiza o livro na lista local
        final index = _livros.indexWhere((l) => l.isbn == livro.isbn);
        if (index != -1) {
          _livros[index] = livro;
        }
      }
    } catch (e) {
      _error = "Erro ao alterar o Livro:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletar um livro
  Future<void> deleteLivro(int idLivro) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _livroService.deleteLivro(idLivro);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        _livros.removeWhere(
            (livro) => livro.idLivro == idLivro); // Remove pelo idLivro
      }
    } catch (e) {
      _error = "Erro ao deletar o Livro:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
