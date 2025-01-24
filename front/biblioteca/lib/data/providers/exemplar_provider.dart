import 'package:biblioteca/data/models/exemplar_model.dart';
import 'package:biblioteca/data/services/exemplar_service.dart';
import 'package:flutter/material.dart';

class ExemplarProvider extends ChangeNotifier {
  final ExemplarService _exemplarService = ExemplarService();
  bool _isLoading = false;
  String? _error;
  List<Exemplar> _exemplares = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasErrors => _error != null;
  List<Exemplar> get exemplares => [..._exemplares];

  // Carregar todos os exemplares de um livro
  Future<void> loadExemplares(int idLivro) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _exemplarService.fetchExemplares(idLivro);

      if (apiResponse.responseCode == 200) {
        _exemplares = apiResponse.body;
      } else {
        _error = apiResponse.body;
      }
    } catch (e) {
      _error = "Erro ao carregar os Exemplares:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Adicionar um novo exemplar
  Future<void> addExemplar(Exemplar exemplar) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _exemplarService.addExemplar(exemplar);

      if (apiResponse.responseCode > 299) {
        _error = apiResponse.body;
      } else {
        _exemplares.add(exemplar);
      }
    } catch (e) {
      _error = "Erro ao inserir novo Exemplar:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Editar um exemplar existente
  Future<void> editExemplar(Exemplar exemplar) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _exemplarService.alterExemplar(exemplar);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        // Atualiza o exemplar na lista local
        final index = _exemplares.indexWhere((e) => e.idExemplar == exemplar.idExemplar);
        if (index != -1) {
          _exemplares[index] = exemplar;
        }
      }
    } catch (e) {
      _error = "Erro ao alterar o Exemplar:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Deletar um exemplar
  Future<void> deleteExemplar(int idExemplar) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiResponse = await _exemplarService.deleteExemplar(idExemplar);

      if (apiResponse.responseCode != 200) {
        _error = apiResponse.body;
      } else {
        _exemplares.removeWhere((exemplar) => exemplar.idExemplar == idExemplar); // Remove pelo idExemplar
      }
    } catch (e) {
      _error = "Erro ao deletar o Exemplar:\n$e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
