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


