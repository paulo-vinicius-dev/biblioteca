import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  num _idDaSessao = 0;
  String usuarioLogado = '';

  num get idDaSessao => _idDaSessao;

  void login(num idDaSessao, String loginDoUsuario) {
    _idDaSessao = idDaSessao;
    usuarioLogado = loginDoUsuario;
    notifyListeners();
  }

  void logout() {
    _idDaSessao = 0;
    usuarioLogado = '';
    notifyListeners();
  }
}
