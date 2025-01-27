import 'package:biblioteca/data/models/autor_model.dart';
import 'package:biblioteca/data/services/autor_service.dart';
import 'package:flutter/material.dart';

class AutorProvider extends ChangeNotifier {
  final AutorService _autorService = AutorService();
  bool _isLoading = false;
  String? _error;
  List<Autor> _autores = [];

  //Uns getters
  bool get isloading => _isLoading;
  String? get error => _error;
  bool get hasErrors => _error != null ? true : false;
  List<Autor> get autores => [..._autores];

  Future<void> loadAutores() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _autorService.fetchAutor();

      if (apiResponse.responseCode == 200) {
        _autores = apiResponse.body;
      } else {
        _error = apiResponse.body;
      }
    } catch (e) {
      _error = "Erro ao carregar os Autores:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAutor(Autor autor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _autorService.addAutor(autor);

      if (apiResponse.responseCode > 299) {
        _error = apiResponse.body;
      } else {
        _autores.add(autor);
      }
    } catch (e) {
      _error = "Erro ao inserir novo Autor:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editAutor(Autor autor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _autorService.alterAutor(autor);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      }
    } catch (e) {
      _error = "Erro ao alterar o Autor:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAutor(Autor autor) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _autorService.deleteAutor(autor.id);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      }
    } catch (e) {
      _error = "Erro ao deletar o Autor:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
