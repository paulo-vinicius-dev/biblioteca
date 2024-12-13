import 'package:biblioteca/tem_tabela/exemplar_model.dart';

import 'book_model.dart';

List<Book> books = List.generate(
  100,
  (index) => Book(
    codigo:'1',
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

List<Book> booksEmprestimo = [
  Book(codigo: '1234', nome: 'Livro 1', isbn: '6314592496', editora: 'Editora A', dataPublicacao: '01/01/2002'),
  Book(codigo: '1235', nome: 'Livro 2', isbn: '2191348416', editora: 'Editora B', dataPublicacao: '01/01/2005'),
  Book(codigo: '1236', nome: 'Livro 3', isbn: '9779666524', editora: 'Editora C', dataPublicacao: '01/01/2010')
];