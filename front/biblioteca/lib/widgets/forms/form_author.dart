import 'package:biblioteca/widgets/navegacao/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/widgets/forms/campo_obrigatorio.dart';

const List<String> sexos = <String>['Masculino', 'Feminino', 'Outro'];

class FormAutor extends StatefulWidget {
  const FormAutor({super.key});

  @override
  State<FormAutor> createState() => _FormAutorState();
}

class _FormAutorState extends State<FormAutor> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _anoNascimentoController = TextEditingController();
  final TextEditingController _nacionalidadeController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _anoNascimentoController.dispose();
    _nacionalidadeController.dispose();
    _sexoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Barra de navegação
        const BreadCrumb(breadcrumb: ['Início','Autores','Novo Autor'], icon: Icons.menu_book_outlined),
        // Formulário
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

                      // Nome
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          label: CampoObrigatorio(label: "Nome"),
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
                      const SizedBox(height: 20.0),

                      // Ano de Nascimento
                      TextFormField(
                        controller: _anoNascimentoController,
                        decoration: const InputDecoration(
                          labelText: "Ano de Nascimento",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                            return "Insira um ano válido";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // Nacionalidade
                      TextFormField(
                        controller: _nacionalidadeController,
                        decoration: const InputDecoration(
                          labelText: "Nacionalidade",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty && !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return "Insira uma nacionalidade válida";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),

                      // Sexo
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Sexo",
                          border: OutlineInputBorder(),
                        ),
                        items: sexos.map((String sexo) {
                          return DropdownMenuItem<String>(
                            value: sexo,
                            child: Text(sexo),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          _sexoController.text = newValue!;
                        },
                      ),
                      const SizedBox(height: 20.0),

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
                                  color: Theme.of(context).colorScheme.onInverseSurface,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),

                          // Salvar
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Cadastro realizado com sucesso!"),
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
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}