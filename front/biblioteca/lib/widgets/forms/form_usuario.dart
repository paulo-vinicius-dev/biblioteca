import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<String> usuarios = <String>['Aluno', 'Funcionário'];

class FormUsuario extends StatefulWidget {
  const FormUsuario({super.key});

  @override
  State<FormUsuario> createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DateTime _today = DateTime.now();
  DateTime? _selectedDate = DateTime.now();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preencha esse campo";
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Insira um email válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //#################################### Aqui começa o campo data
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
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 20.0),
                  DropdownMenu(
                    controller: _userTypeController,
                    width: double.infinity,
                    label: const Text('Selecione o tipo do usuário'),
                    requestFocusOnTap: true,
                    dropdownMenuEntries: usuarios
                        .map(
                          (e) => DropdownMenuEntry(
                            value: 1,
                            label: e,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20.0),
                  //####################################### Aqui começam os botões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Cadastro realizado com sucesso!"),
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
            ],
          ),
        ),

    );
  }
}
