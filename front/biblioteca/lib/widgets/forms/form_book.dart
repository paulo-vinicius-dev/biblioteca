import 'package:flutter/material.dart';

class FormBook extends StatefulWidget {
  const FormBook({super.key});

  @override
  State<FormBook> createState() => _FormBookState();
}

class _FormBookState extends State<FormBook> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _dataPublicacaoController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();
  final TextEditingController _subjectsController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();
    _dataPublicacaoController.dispose();
    _pageCountController.dispose();
    _subjectsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de navegação
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
          color: const Color.fromRGBO(38, 42, 79, 1),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_outlined,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                "Catalogação",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              Text(
                "Livros",
                style: TextStyle(color: Colors.white),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              Text(
                "Novo Livro",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),

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
                      // ISBN
                      TextFormField(
                        controller: _isbnController,
                        decoration: const InputDecoration(
                          labelText: "ISBN",
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

                      // Título
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(
                          labelText: "Título",
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

                      // Editora
                      TextFormField(
                        controller: _editoraController,
                        decoration: const InputDecoration(
                          labelText: "Editora",
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

                      // Data de Publicação
                      TextFormField(
                        controller: _dataPublicacaoController,
                        decoration: const InputDecoration(
                          labelText: "Ano de Publicação",
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

                      
                      
                      // Quantidade de paginas
                      TextFormField(
                        controller: _pageCountController,
                        decoration: const InputDecoration(
                          labelText: "Quantidade de Páginas",
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
                      
                      // Autores
                      // Adicionar lógica para aumentar a quantidade de campos e armazenar os dados em uma lista
                      Row(children: [                          
                        Expanded(
                          child: TextFormField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: "Autores",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Preencha esse campo";
                              }
                              return null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () => {},
                          child: Expanded(
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)
                                ),
                              ),
                              
                              child: const Icon(Icons.add),
                            ),
                          )
                        )
                      ]),
                      const SizedBox(height: 20.0),

                      // Categorias
                      // Adicionar lógica para aumentar a quantidade de campos e armazenar os dados em uma lista
                      Row(children: [                       
                        Expanded(
                          child: TextFormField(
                            controller: _subjectsController,
                            decoration: const InputDecoration(
                              labelText: "Categorias",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Preencha esse campo";
                              }
                              return null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () => {},
                          child: Expanded(
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomRight: Radius.circular(6.0)
                                ),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          )
                        )
                      ]),
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
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
