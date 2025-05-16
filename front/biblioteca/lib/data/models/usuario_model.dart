import 'dart:convert';
import 'package:biblioteca/utils/config.dart';


Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class TipoDeUsuario {
  static const bibliotecario = 'Bibliotecário';
  static const funcionario = 'Funcionário';
  static const aluno = 'Aluno';
}

class Usuario {
  int idDoUsuario;
  String login;
  String? cpf;
  String senha;
  String nome;
  String email;
  String? telefone;
  DateTime? dataDeNascimento;
  int permissao;
  bool ativo;
  int turma;

  String? turmaDescrisao;
  int? serie;
  int? turno;

  Usuario({
    this.idDoUsuario = 0,
    required this.login,
    required this.cpf,
    required this.senha,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.dataDeNascimento,
    required this.permissao,
    this.ativo = true,
    this.turma = 0,
    this.turmaDescrisao,
    this.serie,
    this.turno,
    });



  String get getTurma => turmaDescrisao == null || turmaDescrisao!.isEmpty
      ? 'N/A'
      : turmaDescrisao!.replaceAll(turmaDescrisao!.split(' ').last, '');

  String get getTurno => turmaDescrisao == null || turmaDescrisao!.isEmpty
      ? 'N/A'
      : turmaDescrisao!.split(' ').last;

  String get getTipoDeUsuario => permissao == AppConfig.maxPermissoes
      ? TipoDeUsuario.bibliotecario
      : (turma == 0 ? TipoDeUsuario.funcionario : TipoDeUsuario.aluno);

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        idDoUsuario: json["IdDoUsuario"],
        login: json["Login"],
        cpf: json["Cpf"],
        senha: json["Senha"],
        nome: json["Nome"],
        email: json["Email"],
        telefone: json["Telefone"],
        dataDeNascimento: json["DataDeNascimento"].toString().isEmpty
            ? null
            : DateTime.parse(json["DataDeNascimento"]),
        permissao: json["Permissao"],
        ativo: json["Ativo"],
        turma: json["Turma"],
        turmaDescrisao: json["TurmaDescrisao"],
        serie: json["Serie"],
        turno: json["Turno"],
      );

  Map<String, dynamic> toJson() => {
        "IdDoUsuario": idDoUsuario,
        "Login": login,
        "Cpf": cpf,
        "Senha": senha,
        "Nome": nome,
        "Email": email,
        "Telefone": telefone,
        "DataDeNascimento": dataDeNascimento == null
            ? null
            : "${dataDeNascimento?.year.toString().padLeft(4, '0')}-${dataDeNascimento?.month.toString().padLeft(2, '0')}-${dataDeNascimento?.day.toString().padLeft(2, '0')}",
        "Permissao": permissao,
        "Ativo": ativo,
        "Turma": turma,
        "TurmaDescrisao": turmaDescrisao,
        "Serie": serie,
        "Turno": turno,
      };
}
  