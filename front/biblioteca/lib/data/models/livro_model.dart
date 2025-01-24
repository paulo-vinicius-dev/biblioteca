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
  DateTime dataCriacao;  
  DateTime dataAtualizacao;

  Livro({
    required this.idLivro,
    required this.isbn,
    required this.titulo,
    required this.anoPublicacao,
    required this.editora,
    required this.pais,
    required this.dataCriacao,
    required this.dataAtualizacao,
  });

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
        idLivro: json["idLivro"],
        isbn: json["isbn"],
        titulo: json["titulo"],
        anoPublicacao: DateTime.parse(json["ano_publicacao"]),
        editora: json["editora"],
        pais: json["pais"],
        dataCriacao: DateTime.parse(json["data_criacao"]),
        dataAtualizacao: DateTime.parse(json["data_atualizacao"]),
      );

  Map<String, dynamic> toJson() => {
        "idLivro": idLivro,
        "isbn": isbn,
        "titulo": titulo,
        "ano_publicacao": anoPublicacao.toIso8601String(), 
        "editora": editora,
        "pais": pais,
        "data_criacao": dataCriacao.toIso8601String(),  
        "data_atualizacao": dataAtualizacao.toIso8601String(),  
      };
}
