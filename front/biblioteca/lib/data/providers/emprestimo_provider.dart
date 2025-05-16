// Provider para gerenciar o estado de empresimo
import 'package:biblioteca/data/models/emprestimos_model.dart';
import 'package:biblioteca/data/services/emprestimo_service.dart';
import 'package:flutter/material.dart';


class EmprestimoProvider with ChangeNotifier {
  final EmprestimoService emprestimoService = EmprestimoService();
  final num idDaSessao;
  final String usuarioLogado;
  EmprestimoProvider(this.idDaSessao, this.usuarioLogado);

  Future<List<EmprestimosModel>> fetchEmprestimoUsuario(int idAluno) async {
    try {
     final emprestimos = await emprestimoService.fetchExemplaresUsuario(idDaSessao, usuarioLogado, idAluno);
     return emprestimos;
    } catch (e) {
      print("Erro ao criar empréstimo: $e");
      return [];
    } 
  }
  Future<int?> addEmprestimo(int idAluno, List<int> exemplaresEmprestados) async {
    try {
     final statusCode = await emprestimoService.addEmprestimo(idDaSessao, usuarioLogado, idAluno, exemplaresEmprestados);
     print(statusCode);
     return statusCode;
    } catch (e) {
      print("Erro ao criar empréstimo: $e");
      return null;
    }
  }
}
