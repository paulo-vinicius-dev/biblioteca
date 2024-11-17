import 'package:biblioteca/widgets/menu_navegacao.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';

class TelaPaginaIncial extends StatelessWidget {
  const TelaPaginaIncial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppTheme.drawerBackgroundColor,
        leading: null,
      ),
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(200, 245, 246, 250),
          ),
          const MenuNavegacao(),
        ],
      ),
    );
  }
}
