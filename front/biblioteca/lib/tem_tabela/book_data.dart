import 'book_model.dart';

List<Book> books = List.generate(
  100,
  (index) => Book(
    nome: 'Livro $index',
    isbn: 'ISBN-$index',
    editora: index % 2 == 0 ? 'Editora A' : 'Editora B', // Alterna entre Editora A e Editora B
    dataPublicacao: '01/01/20${index % 30}', // Data de publicação variando entre 2000 e 2029
  ),
);