import 'dart:convert';

Livro livroFromJson(String str) => Livro.fromJson(json.decode(str));

String livroToJson(Livro data) => json.encode(data.toJson());

class Livro {
  int idDoLivro;
  String isbn;
  String titulo;
  DateTime anoPublicacao;
  String editora;
  int pais;

  Livro({
    required this.idDoLivro,
    required this.isbn,
    required this.titulo,
    required this.anoPublicacao,
    required this.editora,
    required this.pais,
  });

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
        idDoLivro: json["idLivro"],
        isbn: json["isbn"],
        titulo: json["titulo"],
        anoPublicacao: DateTime.parse(json["ano_publicacao"]),
        editora: json["editora"],
        pais: json["pais"],
      );

  Map<String, dynamic> toJson() => {
        "idLivro": idDoLivro,
        "isbn": isbn,
        "titulo": titulo,
        "ano_publicacao": anoPublicacao.toIso8601String(), 
        "editora": editora,
        "pais": pais, 
      };
}
