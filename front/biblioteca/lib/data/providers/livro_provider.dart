import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/services/livro_service.dart';
import 'package:flutter/material.dart';

class LivroProvider extends ChangeNotifier {
  final LivroService _livroService = LivroService();
  bool _isLoading = false;
  String? _error;
  List<Livro> _livros = [];
  
  final num idDaSessao;
  final String usuarioLogado;

  LivroProvider(this.idDaSessao, this.usuarioLogado);

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
      final livrosAtingidos = await _livroService.fetchLivros(idDaSessao, usuarioLogado);
      _livros = livrosAtingidos.livrosAtingidos;
    } catch (e) {
      _error = "Provider: Erro ao carregar os Livros:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adicionar um novo livro
  Future<void> addLivro(Livro livro) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Chama o método de adicionar livro
      await _livroService.addLivro(livro);
      
      // Caso o livro seja adicionado com sucesso, adicionamos à lista local
      _livros.add(livro);
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
      // Chama o método de alterar livro
      await _livroService.alterLivro(livro);

      // Atualiza o livro na lista local
      final index = _livros.indexWhere((l) => l.isbn == livro.isbn);
      if (index != -1) {
        _livros[index] = livro;
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
      // Chama o método de deletar livro
      await _livroService.deleteLivro(idLivro);

      // Remove o livro da lista local
      _livros.removeWhere((livro) => livro.idDoLivro == idLivro);
    } catch (e) {
      _error = "Erro ao deletar o Livro:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
