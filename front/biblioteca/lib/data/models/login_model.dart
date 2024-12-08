import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
    num idSessao;
    bool aceito;

    Login({
        required this.idSessao,
        required this.aceito,
    });

    factory Login.fromJson(Map<String, dynamic> json) => Login(
        idSessao: json["IdSessao"],
        aceito: json["Aceito"],
    );

    Map<String, dynamic> toJson() => {
        "IdSessao": idSessao,
        "Aceito": aceito,
    };
}