import 'package:biblioteca/data/models/emprestimos_model.dart';
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

  Future<void> loadUsuarios() async {
    try {
      loadedUsuarios =
          await usuarioService.fetchUsuarios(idDaSessao, usuarioLogado);
      users = loadedUsuarios!.usuarioAtingidos
          .where((usuario) => usuario.ativo && usuario.login != usuarioLogado)
          .toList();

      notifyListeners();
    } catch (e) {
      print('$e');
    }
  }

  Future<void> addUsuario(Usuario usuario) async {
    late Usuario novoUsuario;
    try {
      novoUsuario =
          await usuarioService.addUsuario(idDaSessao, usuarioLogado, usuario);
      users.add(novoUsuario);
    } catch (e) {
      print('$e');
    }
    notifyListeners();
  }

  Future<void> editUsuario(Usuario usuario) async {
    late Usuario novoUsuario;
    try {
      novoUsuario =
          await usuarioService.alterUsuario(idDaSessao, usuarioLogado, usuario);
      users[users.indexOf(usuario)] = novoUsuario;
    } catch (e) {
      print('$e');
    }
    notifyListeners();
  }

  Future<void> deleteUsuario(int idDoUsuario) async {
    late Usuario usuarioDeletado;
    try {
      usuarioDeletado = await usuarioService.deleteUsuario(
          idDaSessao, usuarioLogado, idDoUsuario);
      users.remove(usuarioDeletado);
    } catch (e) {
      print('$e');
    }
    notifyListeners();
  }
}
