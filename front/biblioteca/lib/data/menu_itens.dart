
import 'package:biblioteca/models/modelo_menu.dart';
import 'package:flutter/material.dart';

final List<MenuModelo> menuitens = [
  MenuModelo("Inicio", Icons.home, []),
  MenuModelo("Pesquisar Livro",  Icons.search, []),
  MenuModelo("Circulação", Icons.my_library_books_rounded,["Empréstimo", "Devolução"]),
  MenuModelo("Catalogação", Icons.menu_book_outlined,["Autores", "Livros"]),
  MenuModelo("Documentação", Icons.list_alt_sharp,["Relatórios", "Nada Consta"]),
  MenuModelo("Controle de Usuários",Icons.co_present_rounded,["Usuários"]),
  MenuModelo("Configurações", Icons.settings, [],),
  MenuModelo("Sair", Icons.logout, [])
];

