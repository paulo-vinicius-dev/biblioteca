import 'dart:convert';
import 'package:biblioteca/data/models/livro_model.dart';

LivrosAtingidos livrosAtingidosFromJson(String str) =>
    LivrosAtingidos.fromJson(json.decode(str));

String livrosAtingidosToJson(LivrosAtingidos data) =>
    json.encode(data.toJson());

class LivrosAtingidos {
  List<Livro> livrosAtingidos;

  LivrosAtingidos({
    required this.livrosAtingidos,
  });

  factory LivrosAtingidos.fromJson(Map<String, dynamic> json) =>
      LivrosAtingidos(
        livrosAtingidos: List<Livro>.from(
            json["LivrosAtingidos"].map((x) => Livro.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "LivrosAtingidos":
            List<dynamic>.from(livrosAtingidos.map((x) => x.toJson())),
      };
}
