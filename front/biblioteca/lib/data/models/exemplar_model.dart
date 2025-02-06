class TipoDeStatus {
  static const disponivel = "Disponível";
  static const emprestado = "Indisponível";
}
class TipoEstado{
  static const bom ="Bom";
  static const danificado ="Danificado";
}
class Exemplar {
  final int id;
  final bool cativo;
  final int statusCodigo;
  final int estado;
  final bool ativo;
  final int idLivro;
  final String isbn;
  final String titulo;
  final DateTime anoPublicacao;
  final String editora;
  final int idPais;
  final String nomePais;
  final String siglaPais;

  Exemplar({
    required this.id,
    required this.cativo,
    required this.statusCodigo,
    required this.estado,
    required this.ativo,
    required this.idLivro,
    required this.isbn,
    required this.titulo,
    required this.anoPublicacao,
    required this.editora,
    required this.idPais,
    required this.nomePais,
    required this.siglaPais,
  });

  String get getStatus => statusCodigo == 1
      ? TipoDeStatus.disponivel
      : TipoDeStatus.emprestado;
  String get getEstado => estado == 1
      ? TipoEstado.bom
      : TipoEstado.danificado;
  
  factory Exemplar.fromJson(Map<String, dynamic> json) {
    return Exemplar(
      id: json['IdDoExemplarLivro'],
      cativo: json['Cativo'],
      statusCodigo: json['Status'],
      estado: json['Estado'],
      ativo: json['Ativo'],
      idLivro: json['IdDoLivro'],
      isbn: json['Isbn'],
      titulo: json['Titulo'],
      anoPublicacao: DateTime.parse(json['AnoPublicacao']),
      editora: json['Editora'],
      idPais: json['IdDoPais'],
      nomePais: json['NomePais'],
      siglaPais: json['SiglaPais'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'IdDoExemplarLivro': id,
      'Cativo': cativo,
      'Status': statusCodigo,
      'Estado': estado,
      'Ativo': ativo,
      'IdDoLivro': idLivro,
      'Isbn': isbn,
      'Titulo': titulo,
      'AnoPublicacao': anoPublicacao.toIso8601String(),
      'Editora': editora,
      'IdDoPais': idPais,
      'NomePais': nomePais,
      'SiglaPais': siglaPais,
    };
  }
}