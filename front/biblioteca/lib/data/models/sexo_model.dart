List<Sexo> sexos = [
  Sexo(codigo: 'M', sexo: 'Masculino'),
  Sexo(codigo: 'F', sexo: 'Feminino')
];

class Sexo {
  String codigo;
  String sexo;

  Sexo({required this.codigo, required this.sexo});
}

