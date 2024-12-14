import 'package:biblioteca/widgets/forms/form_redefinir_senha_codigo.dart';
import 'package:flutter/material.dart';

class TelaRedefinirSenhaCodigo extends StatefulWidget {
  const TelaRedefinirSenhaCodigo({super.key});

  @override
  State<TelaRedefinirSenhaCodigo> createState() => _TelaRedefinirSenhaCodigoState();
}

class _TelaRedefinirSenhaCodigoState extends State<TelaRedefinirSenhaCodigo> {
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
              child: FormRedefinirSenhaCodigo(),
            ),
          ),
        ),
      ),
    );
  }
}
