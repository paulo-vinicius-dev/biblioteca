import 'dart:convert';

Pais paisFromJson(String str) => Pais.fromJson(json.decode(str));
String paisToJson(Pais data) => json.encode(data.toJson());

List<Pais> listaDePaisesFromJson(String str) =>
    List<Pais>.from(json.decode(str).map((x) => Pais.fromJson(x)));

String listaDePaisesToJson(List<Pais> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pais {
  int idDoPais;
  String nome;
  String sigla;
  bool ativo;

  Pais({
    required this.idDoPais,
    required this.nome,
    required this.sigla,
    required this.ativo,
  });

  factory Pais.fromJson(Map<String, dynamic> json) {
    return Pais(
      idDoPais: json['IdDoPais'],
      nome: json['Nome'],
      sigla: json['Sigla'],
      ativo: json['Ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdDoPais': idDoPais,
      'Nome': nome,
      'Sigla': sigla,
      'Ativo': ativo,
    };
  }
}
