import 'package:flutter/material.dart';

enum ModoLogin { login, redefinirSenha, recuperarCodigo }
class LoginProvider extends ChangeNotifier {

  ModoLogin _modoLogin = ModoLogin.login;
  ModoLogin get modoLogin => _modoLogin;


  void setModo(ModoLogin novoModo) {
    _modoLogin = novoModo;
    notifyListeners();
  }


}
