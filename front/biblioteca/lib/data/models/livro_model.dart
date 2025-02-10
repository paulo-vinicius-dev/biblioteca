// To parse this JSON data, do
//
//     final livro = livroFromJson(jsonString);

import 'dart:convert';

Livro livroFromJson(String str) => Livro.fromJson(json.decode(str));

String livroToJson(Livro data) => json.encode(data.toJson());

class Livro {
    int idDoLivro;
    String isbn;
    String titulo;
    String anoPublicacao;
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
        idDoLivro: json["IdDoLivro"],
        isbn: json["Isbn"],
        titulo: json["Titulo"],
        anoPublicacao: json["AnoPublicacao"],
        editora: json["Editora"],
        pais: json["Pais"],
    );

    Map<String, dynamic> toJson() => {
        "IdDoLivro": idDoLivro,
        "Isbn": isbn,
        "Titulo": titulo,
        "AnoPublicacao": anoPublicacao,
        "Editora": editora,
        "Pais": pais,
    };
}
