import 'package:biblioteca/widgets/navegacao/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/data/services/isbn_service.dart';

class FormBook extends StatefulWidget {
  const FormBook({super.key});

  @override
  State<FormBook> createState() => _FormBookState();
}

class _FormBookState extends State<FormBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _editoraController = TextEditingController();
  final TextEditingController _dataPublicacaoController =
      TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();

  final List<TextEditingController> _authorsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _categoriesControllers = [
    TextEditingController()
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _isbnController.dispose();
    _editoraController.dispose();
    _dataPublicacaoController.dispose();
    _pageCountController.dispose();

    for (var controller in _authorsControllers) {
      controller.dispose();
    }
    for (var controller in _categoriesControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _buscarLivroPorISBN() async {
    String isbn = _isbnController.text.trim();
    if (isbn.isEmpty) return;

    try {
      final data = await IsbnService.buscarLivroPorISBN(isbn);

      if (data != null) {
        setState(() {
          _tituloController.text = data['title'] ?? '';
          _editoraController.text = data['publisher'] ?? '';
          _dataPublicacaoController.text =
              data['publication_date']?.substring(0, 4) ?? '';
          _pageCountController.text = (data['page_count'] ?? '').toString();

          // Preencher os autores
          _authorsControllers.clear();
          if (data['authors'] != null) {
            for (String autor in data['authors']) {
              _authorsControllers.add(TextEditingController(text: autor));
            }
          }

          // Preencher as categorias
          _categoriesControllers.clear();
          if (data['subjects'] != null) {
            for (String categoria in data['subjects']) {
              _categoriesControllers
                  .add(TextEditingController(text: categoria));
            }
          }
        });
      } else {
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Livro não encontrado'),
      ));
      }
    } catch (e) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
      ));
    }
  }

  void _addAuthorField() {
    setState(() {
      _authorsControllers.add(TextEditingController());
    });
  }

  void _addCategoryField() {
    setState(() {
      _categoriesControllers.add(TextEditingController());
    });
  }

  void _removeAuthorField(int index) {
    setState(() {
      _authorsControllers[index].dispose();
      _authorsControllers.removeAt(index);
    });
  }

  void _removeCategoryField(int index) {
    setState(() {
      _categoriesControllers[index].dispose();
      _categoriesControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de navegação
        const BreadCrumb(
            breadcrumb: ['Início', 'Livros', 'Novo Livro'],
            icon: Icons.menu_book_outlined),

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
                        decoration: InputDecoration(
                          labelText: "ISBN",
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon:  const Icon(Icons.search),
                            onPressed: _buscarLivroPorISBN,
                          ),
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
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Ano de Publicação",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha esse campo";
                          }
                          final testNum = int.tryParse(value);
                          if (testNum == null) {
                            return "Apenas numeros neste campo";
                          }
                          if (testNum > DateTime.now().year) {
                            return "Confira se esta data está correta";
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
                      Column(
                        children:
                            List.generate(_authorsControllers.length, (index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _authorsControllers[index],
                                      decoration: InputDecoration(
                                        labelText: "Autor ${index + 1}",
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  if (index == 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade700,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        onPressed: _addAuthorField,
                                      ),
                                    ),
                                  if (index > 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.white),
                                        onPressed: () =>
                                            _removeAuthorField(index),
                                      ),
                                    ),
                                ],
                              ),
                              if (index < _authorsControllers.length - 1)
                                const SizedBox(height: 16.0),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 20.0),

                      // Categorias
                      Column(
                        children: List.generate(_categoriesControllers.length,
                            (index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _categoriesControllers[index],
                                      decoration: InputDecoration(
                                        labelText: "Categoria ${index + 1}",
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4.0),
                                  if (index == 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade700,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.white),
                                        onPressed: _addCategoryField,
                                      ),
                                    ),
                                  if (index > 0)
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.white),
                                        onPressed: () =>
                                            _removeCategoryField(index),
                                      ),
                                    ),
                                ],
                              ),
                              if (index < _categoriesControllers.length - 1)
                                const SizedBox(height: 16.0),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 20.0),

                      // Botões
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Erro ao preencher o formulario : $_dataPublicacaoController")));
                              }

                              _tituloController.clear();
                              _isbnController.clear();
                              _editoraController.clear();
                              _dataPublicacaoController.clear();
                              _pageCountController.clear();
                              for (var controller in _authorsControllers) {
                                controller.clear();
                              }
                              for (var controller in _categoriesControllers) {
                                controller.clear();
                              }
                              setState(() {
                                _authorsControllers.clear();
                                _categoriesControllers.clear();
                                _authorsControllers
                                    .add(TextEditingController());
                                _categoriesControllers
                                    .add(TextEditingController());
                              });
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
