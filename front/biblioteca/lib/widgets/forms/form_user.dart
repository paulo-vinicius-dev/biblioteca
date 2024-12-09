import 'package:biblioteca/widgets/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/widgets/forms/campo_obrigatorio.dart';
import 'package:intl/intl.dart';

const List<String> usuarios = <String>['Aluno', 'Funcionário', 'Bibliotecário'];
const List<String> turmas = <String>[
  'N/A',
  '1º Ano A',
  '1º Ano B',
  '1º Ano C',
  '2º Ano A',
  '2º Ano B',
  '2º Ano C',
  '3º Ano A',
  '3º Ano B',
  '3º Ano C'
];

const List<String> turnos = <String>[
  'N/A',
  'Matutino',
  'Vespertino',
  'Noturno'
];

class FormUser extends StatefulWidget {
  const FormUser({super.key});

  @override
  State<FormUser> createState() => _FormUserState();
}

class _FormUserState extends State<FormUser> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _turmaController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateTime _today = DateTime.now();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _userTypeController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _dateController.dispose();
    _cpfController.dispose();
    _turmaController.dispose();
    _turnoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Barra de navegação
         BreadCrumb(breadcrumb: ['Início','Usuários','Novo Usuário'], icon: Icons.co_present_rounded),

        // Formulário
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Informações de Acesso
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informações de Acesso",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Tipo de Usuário
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Tipo de Usuário"),
                                  border: OutlineInputBorder(),
                                ),
                                items: usuarios.map((String userType) {
                                  return DropdownMenuItem<String>(
                                    value: userType,
                                    child: Text(userType),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  _userTypeController.text = newValue!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Selecione um tipo de usuário";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Login
                              TextFormField(
                                controller: _loginController,
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Login "),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha esse campo";
                                  } else if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
                                    return "O login não deve conter caracteres especiais, exceto '.', '_' ou '-'";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Senha
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  label: const CampoObrigatorio(label: "Senha"),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: !_passwordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha esse campo";
                                  } else if (value.length < 8) {
                                    return "A senha deve ter pelo menos 8 caracteres";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Confirmar Senha
                              TextFormField(
                                decoration: InputDecoration(
                                  label: const CampoObrigatorio(label: "Confirmar Senha"),
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _confirmPasswordVisible = !_confirmPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: _confirmPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha esse campo";
                                  } else if (value != _passwordController.text) {
                                    return "As senhas não são iguais";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        // Espaçamento
                        const SizedBox(width: 20.0),

                        // Informações Pessoais
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informações Pessoais",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Nome
                              TextFormField(
                                controller: _nomeController,
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Nome") ,
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha esse campo";
                                  } else if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
                                    return "O nome deve conter apenas letras";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Email
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Email") ,
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Preencha esse campo";
                                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return "Insira um email válido";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Telefone
                              TextFormField(
                                controller: _telefoneController,
                                decoration: const InputDecoration(
                                  labelText: "Telefone",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty && value.length != 11) {
                                    return "Insira um telefone válido";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Data de Nascimento
                              TextFormField(
                                readOnly: true,
                                controller: _dateController,
                                decoration: const InputDecoration(
                                  labelText: "Data de Nascimento",
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    locale: const Locale('pt', 'BR'),
                                    initialDate: _today,
                                    firstDate: DateTime(1900),
                                    lastDate: _today,
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      _dateController.text = DateFormat('d/M/y')
                                          .format(pickedDate)
                                          .toString();
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // CPF
                              TextFormField(
                                controller: _cpfController,
                                decoration: const InputDecoration(
                                  labelText: "CPF",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value != null &&
                                      value.isNotEmpty &&
                                      value.length != 11) {
                                    return "Insira um CPF válido";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        // Espaçamento
                        const SizedBox(width: 20.0),

                        // Informações Acadêmicas
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Informações Acadêmicas",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),

                              // Turma
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Turma"),
                                  border: OutlineInputBorder(),
                                ),
                                items: turmas.map((String turma) {
                                  return DropdownMenuItem<String>(
                                    value: turma,
                                    child: Text(turma),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  _turmaController.text = newValue!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Selecione uma turma";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10.0),

                              // Turno
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  label: CampoObrigatorio(label: "Turno"),
                                  border: OutlineInputBorder(),
                                ),
                                items: turnos.map((String turno) {
                                  return DropdownMenuItem<String>(
                                    value: turno,
                                    child: Text(turno),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  _turnoController.text = newValue!;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Selecione um turno";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),

                    // Botões
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Botão Cancelar
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onInverseSurface,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16.0),

                        // Botão Salvar
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Cadastro realizado com sucesso!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Salvar",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
