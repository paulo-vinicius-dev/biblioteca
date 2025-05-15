import 'package:biblioteca/data/models/livro_model.dart';
import 'package:biblioteca/data/models/autor_model.dart';
import 'package:biblioteca/data/providers/livro_provider.dart';
import 'package:biblioteca/widgets/navegacao/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteca/widgets/tables/exemplar_table_page.dart';

class ObrasPage extends StatefulWidget {
  final Autor autor;
  const ObrasPage({super.key, required this.autor});

  @override
  State<ObrasPage> createState() => _ObrasPageState();
}

class _ObrasPageState extends State<ObrasPage> {
  bool isLoading = true;
  List<Livro> livrosDoAutor = [];

  @override
  void initState() {
    super.initState();
    _loadLivrosDoAutor();
  }

  Future<void> _loadLivrosDoAutor() async {
    final livrosProvider = Provider.of<LivroProvider>(context, listen: false);
    await livrosProvider.loadLivros();

    livrosDoAutor = livrosProvider.livros
        .where((livro) => livro.autores.any((autor) =>
            autor is Map<String, dynamic> &&
            autor['nome'] == widget.autor.nome))
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  String _getCategoriaDescricao(Livro livro) {
    if (livro.categorias.isEmpty) return 'Sem categoria';

    final primeira = livro.categorias.first;

    if (primeira is Map<String, dynamic> && primeira.containsKey('Descricao')) {
      return primeira['Descricao'];
    }

    return 'Sem categoria';
  }

  void _abrirExemplares(Livro livro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExemplaresPage(book: livro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          BreadCrumb(
            breadcrumb: ['Inicio', 'Autores', 'Obras: ${widget.autor.nome}'],
            icon: Icons.menu_book_outlined,
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
              child: Column(
                children: [
                  Table(
                    border: TableBorder.all(
                      color: const Color.fromARGB(215, 200, 200, 200),
                    ),
                    columnWidths: const {
                      0: IntrinsicColumnWidth(), // ícone
                      1: FlexColumnWidth(3), // título
                      2: FlexColumnWidth(2), // ISBN
                      3: FlexColumnWidth(2), // categoria
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 44, 62, 80),
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(''),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Título',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'ISBN',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Categoria',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                      for (var livro in livrosDoAutor)
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(Icons.menu_book),
                                tooltip: 'Ver exemplares',
                                iconSize: 18,
                                constraints: const BoxConstraints(
                                  minWidth: 25,
                                  minHeight: 25,
                                ),
                                onPressed: () => _abrirExemplares(livro),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(livro.titulo),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(livro.isbn),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(_getCategoriaDescricao(livro)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
