import 'package:flutter/material.dart';
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
  final TextEditingController _turmaController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateTime _today = DateTime.now();
  DateTime? _selectedDate = DateTime.now();

  @override
  void dispose() {
    _passwordController.dispose();
    _userTypeController.dispose();
    _turmaController.dispose();
    _turnoController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
          color: const Color.fromRGBO(38, 42, 79, 1),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.co_present_rounded,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Controle de Usuários",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              Text(
                "Usuários",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              Text(
                "Novo Usuário",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Tipo de Usuário
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Tipo de Usuário",
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
                      const SizedBox(height: 20.0),

                      // Turma
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Turma",
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
                          labelText: "Turno",
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
                      const SizedBox(height: 10.0),

                      // Nome
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      // RA / Matrícula
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "R.A / Matricula",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      // Email
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
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
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _today,
                            firstDate: DateTime(1900),
                            lastDate: _today,
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateController.text = DateFormat('d/M/y')
                                  .format(pickedDate)
                                  .toString();
                            });
                          }
                        },
                        validator: (value) {
                          if (_selectedDate == null) {
                            return "Por favor, selecione uma data.";
                          } else if (_selectedDate!.isAtSameMomentAs(_today) ||
                              _selectedDate!.isAfter(_today)) {
                            return "A data deve ser anterior a hoje.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      // Login
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Login",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      // Senha
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Senha",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
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
                        decoration: const InputDecoration(
                          labelText: "Confirme sua senha",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          } else if (value != _passwordController.text) {
                            return "As senhas não são iguais";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10.0),

                      // Botões
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Cancelar
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
                          const SizedBox(
                            width: 16.0,
                          ),

                          // Salvar
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Cadastro realizado com sucesso!"),
                                      backgroundColor: Colors.green),
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
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
        ),
      ],
    );
  }
}
