import 'package:biblioteca/screens/redefinir_senha.dart';
import 'package:flutter/material.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  final _formLoginKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _visiblePassword = false;

  void tooglePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  String? isNotNull(campo) {
    if (campo == null || campo.isEmpty) {
      return 'Preencha esse campo';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formLoginKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.scaleDown,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Entre com o seu usuário e senha'),
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: _userController,
            decoration: const InputDecoration(
              labelText: 'Usuário',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (user) => isNotNull(user),
          ),
          const SizedBox(height: 20),
          // ---- Senha Começa aqui #########
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                prefixIcon:   const Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: () {
                      tooglePassword();
                    },
                    icon: Icon(_visiblePassword
                        ? Icons.visibility
                        : Icons.visibility_off))),
            obscureText: _visiblePassword,
            validator: (pass) => isNotNull(pass),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _formLoginKey.currentState!.validate();
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const PaginaIncial()),
                //     (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaRedefinirSenha()),
              );
            },
            child: Text(
              'Esqueceu sua senha?',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
