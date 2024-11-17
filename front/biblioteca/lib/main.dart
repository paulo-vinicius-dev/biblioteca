import 'package:biblioteca/screens/login.dart';
import 'package:biblioteca/screens/pagina_inicial.dart';
import 'package:biblioteca/screens/redefinir_senha.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
          colorScheme: AppTheme.colorScheme,
          scaffoldBackgroundColor: AppTheme.scaffoldBackgroundColor,
          fontFamily: "Nunito"),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (ctx) => const TelaLogin(),
        AppRoutes.home: (ctx) => TelaPaginaIncial(),
        AppRoutes.redefinirSenha: (ctx) => const TelaRedefinirSenha(),
      },
    );
  }
}
