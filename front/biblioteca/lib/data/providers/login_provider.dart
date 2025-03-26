import 'package:biblioteca/data/services/redefinir_senha_service.dart';
import 'package:flutter/material.dart';

enum ModoLogin { login, redefinirSenha, recuperarCodigo }

class LoginProvider extends ChangeNotifier {
  RedefinirSenhaService _redefinirSenhaService = RedefinirSenhaService();
  String _error = "";

  String get error => _error;

  ModoLogin _modoLogin = ModoLogin.login;

  ModoLogin get modoLogin => _modoLogin;

  set modoLogin(ModoLogin modoLogin) {
    _modoLogin = modoLogin;
  }

  void setModo(ModoLogin novoModo) {
    _modoLogin = novoModo;
    notifyListeners();
  }

  set redefinirSenhaService(RedefinirSenhaService service) {
  _redefinirSenhaService = service;
}

  Future<void> enviarEmailDeRecuperacao(String email) async {
    _error = "";
    print("entrei no provider");

    try {
      final apiResponse = await _redefinirSenhaService.enviarEmail(email);

      print("o statusCode é ${apiResponse.responseCode}");

      if (apiResponse.responseCode != 200) {
        _error =
            'O e-mai "$email" não está cadastrado ou não foi possível encontrá-lo. Entre em contato com a biblioteca para alterar seus dados.';
      }
    } catch (e) {
      print("cai aqui: $e \n ${e.runtimeType}");
      _error =
          "Não foi possível enviar o e-mail de recuperação. Tente novamente mais tarde.";
    } finally {
      notifyListeners();
    }
  }

  Future<void> alterarSenha(String codigo, String novaSenha) async {
    _error = "";

    try {
      final apiResponse =
          await _redefinirSenhaService.redefinirSenha(codigo, novaSenha);

      if (apiResponse.responseCode != 200) {
        _error =
            'Não foi possível alterar a senha. Verifique se o código de recuperação está correto e tente novamente.';
      }
    } catch (e) {
      _error = "Não foi possível alterar a senha. Tente novamente mais tarde.";
    } finally {
      notifyListeners();
    }
  }
}
