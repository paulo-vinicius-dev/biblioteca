import 'dart:convert';

Turma turmaFromJson(String str) => Turma.fromJson(json.decode(str));

String turmaToJson(Turma data) => json.encode(data.toJson());

class Turma {
    int turma;
    String descricao;
    int serie;
    int turno;

    Turma({
        required this.turma,
        required this.descricao,
        required this.serie,
        required this.turno,
    });

    factory Turma.fromJson(Map<String, dynamic> json) => Turma(
        turma: json["Turma"],
        descricao: json["Descricao"],
        serie: json["Serie"],
        turno: json["Turno"],
    );

    Map<String, dynamic> toJson() => {
        "Turma": turma,
        "Descricao": descricao,
        "Serie": serie,
        "Turno": turno,
    };
}
