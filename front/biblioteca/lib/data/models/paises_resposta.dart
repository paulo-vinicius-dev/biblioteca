import 'dart:convert';
import 'package:biblioteca/data/models/paises_model.dart';

PaisesAtingidos paisesAtingidosFromJson(String str) =>
    PaisesAtingidos.fromJson(json.decode(str));

String paisesAtingidosToJson(PaisesAtingidos data) =>
    json.encode(data.toJson());

class PaisesAtingidos {
  List<Pais> paisesAtingidos;

  PaisesAtingidos({required this.paisesAtingidos});

  factory PaisesAtingidos.fromJson(Map<String, dynamic> json) {
    return PaisesAtingidos(
      paisesAtingidos:
          (json['Paises'] as List<dynamic>?)?.map((item) => Pais.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    "PaisesAtingidos": List<dynamic>.from(paisesAtingidos.map((x) => x.toJson())),
  };
}
