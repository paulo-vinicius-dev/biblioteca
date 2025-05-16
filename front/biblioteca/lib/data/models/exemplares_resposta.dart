import 'dart:convert';
import 'package:biblioteca/data/models/exemplar_model.dart';

ExemplaresAtingidos exemplaresAtingidosFromJson(String str) =>
    ExemplaresAtingidos.fromJson(json.decode(str));

String exemplaresAtingidosToJson(ExemplaresAtingidos data) =>
    json.encode(data.toJson());

class ExemplaresAtingidos {
  List<Exemplar> exemplares;

  ExemplaresAtingidos({
    required this.exemplares,
  });

  factory ExemplaresAtingidos.fromJson(Map<String, dynamic> json) =>
      ExemplaresAtingidos(
        exemplares: List<Exemplar>.from(
            json["Exemplares"].map((x) => Exemplar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Exemplares": List<dynamic>.from(exemplares.map((x) => x.toJson())),
      };
}

ExemplaresEnvioAtingidos exemplaresEnvioAtingidosFromJson(String str) =>
    ExemplaresEnvioAtingidos.fromJson(json.decode(str));

String exemplaresEnvioAtingidosToJson(ExemplaresEnvioAtingidos data) =>
    json.encode(data.toJson());

class ExemplaresEnvioAtingidos {
  List<ExemplarEnvio> exemplaresEnvio;

  ExemplaresEnvioAtingidos({
    required this.exemplaresEnvio,
  });

  factory ExemplaresEnvioAtingidos.fromJson(Map<String, dynamic> json) =>
      ExemplaresEnvioAtingidos(
        exemplaresEnvio: List<ExemplarEnvio>.from(
            json["Exemplares"].map((x) => ExemplarEnvio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Exemplares":
            List<dynamic>.from(exemplaresEnvio.map((x) => x.toJson())),
      };
}
