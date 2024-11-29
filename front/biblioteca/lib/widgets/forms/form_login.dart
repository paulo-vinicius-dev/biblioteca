// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:biblioteca/utils/assets.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  void showError(error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.8),
      ),
    );
  }

  doLogin(String user, String password) async {
    var url = Uri.http('localhost:9090', '/login');

    http
        .post(url,
            body: jsonEncode({
              'Login': user,
              'Senha': password,
            }))
        .then((response) {
      var responseLogin = jsonDecode(response.body);

      if (response.statusCode == 200 && responseLogin['Aceito']) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (response.statusCode == 200 && !responseLogin['Aceito']) {
        showError('Usuário ou senha incorretos');
      }
    }).catchError((err) {
      showError("Ops! Ocorreu um erro ao tentar realizar o Login");
    });
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
            AppAssets.logo,
            scale: 1.5,
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
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Usuário',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (user) => isNotNull(user),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Senha',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  tooglePassword();
                },
                icon: Icon(
                    _visiblePassword ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            obscureText: !_visiblePassword,
            validator: (pass) => isNotNull(pass),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formLoginKey.currentState!.validate()) {
                  doLogin(_userController.text, _passwordController.text);
                }
              },
              style: AppTheme.btnPrimary(context),
              child: Text(
                'Entrar',
                style: AppTheme.btnPrimaryText(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.redefinirSenha);
            },
            child: Text(
              'Esqueceu sua senha?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
