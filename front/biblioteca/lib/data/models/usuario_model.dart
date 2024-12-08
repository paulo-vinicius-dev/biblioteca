// To parse this JSON data, do
//
//     final usuariosAtingidos = usuariosAtingidosFromJson(jsonString);

import 'dart:convert';

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

class Usuario {
  int idDoUsuario;
  String login;
  String cpf;
  String senha;
  String nome;
  String email;
  String telefone;
  DateTime dataDeNascimento;
  int permissao;
  bool ativo;
  int turma;

  //Esses Campos diferem da tabela precisam ser organizados
  String turno = 'M';
  String tipoUsuario = 'Wtvr';
  String matricula = '0';

  Usuario({
    required this.idDoUsuario,
    required this.login,
    required this.cpf,
    required this.senha,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.dataDeNascimento,
    required this.permissao,
    required this.ativo,
    required this.turma,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idDoUsuario: json["IdDoUsuario"],
        login: json["Login"],
        cpf: json["Cpf"],
        senha: json["Senha"],
        nome: json["Nome"],
        email: json["Email"],
        telefone: json["Telefone"],
        dataDeNascimento: DateTime.parse(json["DataDeNascimento"]),
        permissao: json["Permissao"],
        ativo: json["Ativo"],
        turma: json["Turma"],
      );

  Map<String, dynamic> toJson() => {
        "IdDoUsuario": idDoUsuario,
        "Login": login,
        "Cpf": cpf,
        "Senha": senha,
        "Nome": nome,
        "Email": email,
        "Telefone": telefone,
        "DataDeNascimento":
            "${dataDeNascimento.year.toString().padLeft(4, '0')}-${dataDeNascimento.month.toString().padLeft(2, '0')}-${dataDeNascimento.day.toString().padLeft(2, '0')}",
        "Permissao": permissao,
        "Ativo": ativo,
        "Turma": turma,
      };
}
