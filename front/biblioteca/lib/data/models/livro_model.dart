import 'dart:convert';

Livro livroFromJson(String str) => Livro.fromJson(json.decode(str));

String livroToJson(Livro data) => json.encode(data.toJson());

class Livro {
  int idLivro;
  String isbn;
  String titulo;
  DateTime anoPublicacao;
  String editora;
  int pais;

  Livro({
    required this.idLivro,
    required this.isbn,
    required this.titulo,
    required this.anoPublicacao,
    required this.editora,
    required this.pais,
  });

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
        idLivro: json["idLivro"],
        isbn: json["isbn"],
        titulo: json["titulo"],
        anoPublicacao: DateTime.parse(json["anoPublicacao"]),
        editora: json["editora"],
        pais: json["pais"],
      );

  Map<String, dynamic> toJson() => {
        "idLivro": idLivro,
        "isbn": isbn,
        "titulo": titulo,
        "anoPublicacao": anoPublicacao.toIso8601String(),
        "editora": editora,
        "pais": pais,
      };
}
