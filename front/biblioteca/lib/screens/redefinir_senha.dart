import 'package:flutter/material.dart';

class TelaRedefinirSenha extends StatefulWidget {
  @override
  _TelaRedefinirSenhaState createState() => _TelaRedefinirSenhaState();
}

class _TelaRedefinirSenhaState extends State<TelaRedefinirSenha> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Função de envio da redefinição de senha
  void _resetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui você pode adicionar a lógica para redefinir a senha, como chamar uma API.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Redefinição de senha solicitada para: ${_emailController.text}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Insira seu e-mail para redefinir a senha.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Por favor, insira um e-mail.';
                  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetPassword,
                child: Text('Redefinir Senha'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Voltar à tela de login
                  Navigator.pop(context);
                },
                child: Text('Voltar para Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
