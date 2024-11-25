import 'package:biblioteca/tem_tabela/user_model.dart';

List<User> users = List.generate(
  20,
  (index) => User(
    nome: 'Usuário $index',
    matricula: '00$index',
    dataNascimento: '01/01/199${index % 10}',
    tipoUsuario: index % 2 == 0 ? 'Docente' : 'Discente',
  ),
);
