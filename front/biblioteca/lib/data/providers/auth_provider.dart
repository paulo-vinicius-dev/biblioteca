import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  int? _idDaSessao;
  String? _loginDoUsuario;

  int? get idDaSessao => _idDaSessao;
  String? get usuarioLogado => _loginDoUsuario;

  void login(int idDaSessao, String loginDoUsuario) {
    _idDaSessao = idDaSessao;
    _loginDoUsuario = loginDoUsuario;
    notifyListeners();
  }

  void logout(int idDaSessao, String loginDoUsuario) {
    _idDaSessao = null;
    _loginDoUsuario = null;
    notifyListeners();
  }
}
