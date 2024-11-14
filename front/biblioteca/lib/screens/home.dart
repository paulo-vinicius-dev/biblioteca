import 'package:biblioteca/widgets/menu_navegacao.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';

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
          Container(color: Color.fromARGB(200, 245, 246, 250),),
          MenuNavegacao(),
        ],
      ),

    );
  }
}