import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  int? _idDaSessao;
  String? usuarioLogado;

  int? get idDaSessao => _idDaSessao;

  set idDaSessao(int? idDaSessao) {
    if (idDaSessao == null) {
      _idDaSessao = 0;
    } else {
      _idDaSessao = idDaSessao;
    }
  }

  void login(int idDaSessao, String loginDoUsuario) {
    _idDaSessao = idDaSessao;
    usuarioLogado = loginDoUsuario;
    notifyListeners();
  }

  void logout(int idDaSessao, String loginDoUsuario) {
    _idDaSessao = null;
    usuarioLogado = null;
    notifyListeners();
  }
}
