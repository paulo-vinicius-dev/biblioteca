import 'package:biblioteca/widgets/forms/form_redefinir_senha.dart';
import 'package:flutter/material.dart';

class TelaRedefinirSenha extends StatefulWidget {
  const TelaRedefinirSenha({super.key});

  @override
  State<TelaRedefinirSenha> createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: FormRedefinirSenha(),
            ),
          ),
        ),
      ),
    );
  }
}
