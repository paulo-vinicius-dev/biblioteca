import 'package:biblioteca/tem_tabela/exemplar_model.dart';

class Book {
  final String codigo;
  final String nome;
  final String isbn;
  final String editora;
  final String dataPublicacao;

  final List<Exemplar>? exemplares;

  Book({
    required this.codigo,
    required this.nome,
    required this.isbn,
    required this.editora,
    required this.dataPublicacao,
    required this.exemplares,
  });
}
