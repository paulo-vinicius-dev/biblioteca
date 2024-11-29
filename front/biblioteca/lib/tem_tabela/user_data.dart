import 'package:biblioteca/tem_tabela/user_model.dart';

List<User> users = List.generate(
  100,
  (index) => User(
    nome: 'Usuário $index',
    matricula: '00$index',
    turma: 'Turma ${index % 5 + 1}', // Atribui uma turma de 1 a 5
    turno: index % 2 == 0 ? 'Manhã' : 'Tarde', // Alterna entre manhã e tarde
    tipoUsuario: index % 2 == 0 ? 'Docente' : 'Discente',
  ),
);
