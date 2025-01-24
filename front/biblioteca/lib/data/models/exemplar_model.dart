import 'dart:convert';

Exemplar exemplarFromJson(String str) => Exemplar.fromJson(json.decode(str));

String exemplarToJson(Exemplar data) => json.encode(data.toJson());

class Exemplar {
  int idExemplar;
  int idLivro;
  String codigoExemplar;
  String estado;

  Exemplar({
    required this.idExemplar,
    required this.idLivro,
    required this.codigoExemplar,
    required this.estado,
  });

  factory Exemplar.fromJson(Map<String, dynamic> json) => Exemplar(
        idExemplar: json["idExemplar"],
        idLivro: json["idLivro"],
        codigoExemplar: json["codigoExemplar"],
        estado: json["estado"],
      );

  Map<String, dynamic> toJson() => {
        "idExemplar": idExemplar,
        "idLivro": idLivro,
        "codigoExemplar": codigoExemplar,
        "estado": estado,
      };
}
