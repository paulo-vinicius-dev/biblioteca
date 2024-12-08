import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/services/usuario_service.dart';
import 'package:flutter/material.dart';

class UsuarioProvider with ChangeNotifier {
  final usuarioService = UsuarioService();
  final num idDaSessao;
  final String usuarioLogado;

  UsuarioProvider(this.idDaSessao, this.usuarioLogado);

  List<Usuario> users = [];
  UsuariosAtingidos? loadedUsuarios;
  String? error;

  Future<void> loadUsuarios() async {
    try {
      loadedUsuarios =
          await usuarioService.fetchUsuarios(idDaSessao, usuarioLogado);
      users = loadedUsuarios!.usuarioAtingidos;
    } catch (e) {
      error = e.toString();
      print('$e');
    }
    notifyListeners();
  }
}
