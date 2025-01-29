import 'package:biblioteca/data/providers/login_provider.dart';
import 'package:biblioteca/data/services/redefinir_senha_service.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormRedefinirSenha extends StatefulWidget {
  const FormRedefinirSenha({super.key});

  @override
  State<FormRedefinirSenha> createState() => _FormRedefinirSenhaState();
}

class _FormRedefinirSenhaState extends State<FormRedefinirSenha> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    

    void resetPassword(context) async {
      
      await Provider.of<LoginProvider>(context, listen: false).enviarEmailDeRecuperacao(_emailController.text);
      String error = Provider.of<LoginProvider>(context, listen: false).error;
      if (error.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "O link de recuperação de senha foi enviado para o email '${_emailController.text}', verifique sua caixa de entrada",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Provider.of<LoginProvider>(context, listen: false)
            .setModo(ModoLogin.recuperarCodigo);
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Redefinir senha',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 42.0, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Text(
            'Insira seu email para redefinir a senha',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (email) {
              if (email == null || email.isEmpty) {
                return 'Preencha esse campo';
              } else if (!RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                  .hasMatch(email)) {
                return 'Insira um email válido';
              }


              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                resetPassword(context);
              },
              style: AppTheme.btnPrimary(context),
              child: Text(
                'Enviar',
                style: AppTheme.btnPrimaryText(context),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              // Voltar à tela de login
              Provider.of<LoginProvider>(context, listen: false)
                  .setModo(ModoLogin.login);
            },
            child: const Text('Voltar para o Login'),
          ),
        ],
      ),
    );
  }
}
