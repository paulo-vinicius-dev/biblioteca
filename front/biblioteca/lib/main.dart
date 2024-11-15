import 'package:biblioteca/screens/login.dart';
import 'package:biblioteca/screens/pagina_inicial.dart';
import 'package:biblioteca/screens/redefinir_senha.dart';
import 'package:biblioteca/utils/routes.dart';
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
      initialRoute: Routes.login,
      routes: {
        Routes.login: (ctx) => const TelaLogin(),
        Routes.home: (ctx) => const TelaPaginaIncial(),
        Routes.redefinirSenha: (ctx) => TelaRedefinirSenha(),
      },
    );
  }
}