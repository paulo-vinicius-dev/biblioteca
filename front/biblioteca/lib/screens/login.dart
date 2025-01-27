import 'package:biblioteca/widgets/forms/form_login.dart';
import 'package:flutter/material.dart';

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
              colors: [ Color(0xFF8CA6DF), Color(0xFF3A4CA6), Color(0xFF262A4F)],
            ),
          ),
        ),
        const Center(
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
      ],
    ));
  }
}
