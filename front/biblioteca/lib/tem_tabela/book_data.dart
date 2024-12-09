import 'package:biblioteca/tem_tabela/exemplar_model.dart';

import 'book_model.dart';

List<Book> books = List.generate(
  100,
  (index) => Book(
    nome: 'Livro $index',
    isbn: 'ISBN-$index',
    editora: index % 2 == 0 ? 'Editora A' : 'Editora B', 
    dataPublicacao: '01/01/20${index % 30}',   
    exemplares: List.generate(
      5,
      (index) => Exemplar(nomePai: 'Livro $index', situacao: index % 2 == 0 ? 'Esprestado' : 'Disponivel' , estado: index % 2 == 0 ? 'Bom' : 'Danificado')
    )
  ),
);