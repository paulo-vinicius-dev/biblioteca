import 'package:biblioteca/data/providers/login_provider.dart';
import 'package:biblioteca/widgets/forms/form_login.dart';
import 'package:biblioteca/widgets/forms/form_redefinir_senha.dart';
import 'package:biblioteca/widgets/forms/form_redefinir_senha_codigo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.05, 0.2, 0.6],
              colors: [ Color(0xFF8CA6DF), Color(0xFF3A4CA6), Color(0xFF262A4F)],
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset('assets/images/escola_do_mar.jpg', fit: BoxFit.cover),
          ),
        ),
        Center(
          child: SizedBox(
            width: 500,
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: switch (Provider.of<LoginProvider>(context).modoLogin) {
                  ModoLogin.login => const FormLogin(),
                  ModoLogin.redefinirSenha => const FormRedefinirSenha(),
                  ModoLogin.recuperarCodigo => const FormRedefinirSenhaCodigo(),
                },
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
