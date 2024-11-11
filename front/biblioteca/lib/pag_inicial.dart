import 'package:flutter/material.dart';
import 'package:sistema_biblioteca/Menu/menu_navegacao.dart';
import 'package:sistema_biblioteca/theme.dart';

class PaginaIncial extends StatelessWidget {
  const PaginaIncial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: drawerBackgroundColor,

      ),
      body: Stack(
        children: [
          Container(color: Colors.white,),
          MenuNavegacao(),
        ],
      ),

    );
  }
}