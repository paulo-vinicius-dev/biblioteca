import 'author_model.dart';

List<Author> authors = List.generate(
  100,
  (index) => Author(
    nome: 'Autor $index',
    anoNascimento: 1970 + (index % 30), // Ano de nascimento entre 1970 e 1999
    nacionalidade: index % 2 == 0 ? 'Brasileiro' : 'Americano', // Alterna entre Brasileiro e Americano
    sexo: index % 2 == 0 ? 'Masculino' : 'Feminino', // Alterna entre Masculino e Feminino
  ),
);