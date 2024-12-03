import 'package:flutter/material.dart';

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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
          color: const Color.fromRGBO(38, 42, 79, 1),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_outlined, color: Colors.white, size: 20,),
              SizedBox(width: 7,),
              Text("Catalogação", style: TextStyle(color: Colors.white),),
              Icon(Icons.chevron_right, color: Colors.white,),
              Text("Autores", style: TextStyle(color: Colors.white),),
              Icon(Icons.chevron_right, color: Colors.white,),
              Text("Novo Autor", style: TextStyle(color: Colors.white),)
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
                      // Nome
                      TextFormField(
                        controller: _nomeController,
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
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          } else if (int.tryParse(value) == null) {
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
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Selecione um sexo";
                          }
                          return null;
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