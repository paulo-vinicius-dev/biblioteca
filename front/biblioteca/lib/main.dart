import 'package:biblioteca/screens/login.dart';
import 'package:biblioteca/screens/pagina_inicial.dart';
import 'package:biblioteca/screens/redefinir_senha.dart';
import 'package:biblioteca/utils/rotas.dart';
import 'package:flutter/material.dart';



void main(){
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF262A4F)),
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
        fontFamily: "Nunito"
      ),
      initialRoute: Rotas.login,
      routes: {
        Rotas.login: (ctx) => const TelaLogin(),
        Rotas.home: (ctx) => const TelaPaginaIncial(),
        Rotas.redefinirSenha: (ctx) => TelaRedefinirSenha(),
      },
    );
  }
}