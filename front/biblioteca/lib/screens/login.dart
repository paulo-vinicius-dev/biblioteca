import 'package:biblioteca/widgets/form_login.dart';
import 'package:flutter/material.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

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
              child: FormLogin(),
            ),
          ),
        ),
      ),
    );
  }
}
