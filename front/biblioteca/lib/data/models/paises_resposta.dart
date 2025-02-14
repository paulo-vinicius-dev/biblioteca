import 'dart:convert';
import 'package:biblioteca/data/models/paises_model.dart';

PaisesAtingidos livrosAtingidosFromJson(String str) =>
    PaisesAtingidos.fromJson(json.decode(str));

String livrosAtingidosToJson(PaisesAtingidos data) =>
    json.encode(data.toJson());

class PaisesAtingidos {
  List<Pais> paisesAtingidos;

  PaisesAtingidos({required this.paisesAtingidos});

  factory PaisesAtingidos.fromJson(Map<String, dynamic> json) {
    return PaisesAtingidos(
      paisesAtingidos:
          (json['paises'] as List).map((item) => Pais.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "PaisesAtingidos": List<dynamic>.from(paisesAtingidos.map((x) => x.toJson())),
  };
}
