import 'package:flutter/material.dart';

class MenuModelo {
  final String title;
  final IconData icon;
  final List<SubMenuModelo> submenus;
  final String? route;

  MenuModelo(this.title, this.icon, this.submenus, {this.route});
}

class SubMenuModelo {
  final String title;
  final String route;

  SubMenuModelo(this.title, this.route);
}

List<MenuModelo> menuitens = [
  MenuModelo("Inicio", Icons.home, [], route: "/inicio"),
  MenuModelo("Pesquisar Livro", Icons.search, [], route: "/pesquisar_livro"),
  MenuModelo("Circulação", Icons.my_library_books_rounded, [
    SubMenuModelo("Empréstimo", "/emprestimo"),
    SubMenuModelo("Devolução", "/devolucao")
  ]),
  MenuModelo("Catalogação", Icons.menu_book_outlined, [
    SubMenuModelo("Autores", "/autores"),
    SubMenuModelo("Livros", "/livros")
  ]),
  MenuModelo("Documentação", Icons.list_alt_sharp, [
    SubMenuModelo("Relatórios", "/relatorios"),
    SubMenuModelo("Nada Consta", "/nada_consta")
  ]),
  MenuModelo("Controle de Usuários", Icons.co_present_rounded, [
    SubMenuModelo("Usuários", "/usuarios")
  ]),
  MenuModelo("Configurações", Icons.settings, [], route: "/configuracoes"),
  MenuModelo("Sair", Icons.logout, [], route: "/sair")
];
