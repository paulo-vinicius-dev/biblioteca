import 'dart:convert';

import 'package:biblioteca/data/models/usuario_model.dart';

UsuariosAtingidos usuariosAtingidosFromJson(String str) =>
    UsuariosAtingidos.fromJson(json.decode(str));

String usuariosAtingidosToJson(UsuariosAtingidos data) =>
    json.encode(data.toJson());

class UsuariosAtingidos {
  List<Usuario> usuarioAtingidos;

  UsuariosAtingidos({
    required this.usuarioAtingidos,
  });

  factory UsuariosAtingidos.fromJson(Map<String, dynamic> json) =>
      UsuariosAtingidos(
        usuarioAtingidos: List<Usuario>.from(
            json["UsuarioAtingidos"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "UsuarioAtingidos":
            List<dynamic>.from(usuarioAtingidos.map((x) => x.toJson())),
      };
}
