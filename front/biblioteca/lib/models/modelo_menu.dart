import 'package:flutter/material.dart';

class MenuModelo{
  String title;
  IconData icon;
  

  MenuModelo(this.title, this.icon);
}

List<MenuModelo> menuitens = [
  MenuModelo("Circulação", Icons.my_library_books_rounded),
  MenuModelo("Catalogação", Icons.menu_book_outlined),
  MenuModelo("Documentação", Icons.list_alt_sharp),
  MenuModelo("Controle de Usuários",Icons.co_present_rounded)
];

List<List<String>> menuSubItens = [
  ["Empréstimo", "Devolução"],
  ["Autores", "Livros"],
  ["Relatórios", "Nada Consta"],
  ["Usuários"]
];



