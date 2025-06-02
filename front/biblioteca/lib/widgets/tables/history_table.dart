// ignore_for_file: use_build_context_synchronously
import 'package:biblioteca/data/models/emprestimos_model.dart';
import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/providers/emprestimo_provider.dart';
import 'package:biblioteca/widgets/navegacao/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryTablePage extends StatefulWidget {
  const HistoryTablePage({super.key, this.usuario});
  final Usuario? usuario;

  @override
  HistoryTablePageState createState() => HistoryTablePageState();
}

class HistoryTablePageState extends State<HistoryTablePage> {
  //TextEditingController _buscaController = TextEditingController();

  int rowsPerPage = 10; // Quantidade de linhas por página
  final List<int> rowsPerPageOptions = [5, 10, 15, 20];
  int currentPage = 1; // Página atual

  bool _isLoading = true;
  late List<EmprestimosModel> emprestimos;

  @override
  void initState() {
    super.initState();
    emprestimos = [];
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    if (widget.usuario != null) {
      await carregarEmprestimosUsuario(widget.usuario!.idDoUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : getPage();
  }

  Future<void> carregarEmprestimosUsuario(int idUsuario) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<EmprestimosModel> fetchEmprestimos =
          await Provider.of<EmprestimoProvider>(context, listen: false)
              .fetchEmprestimoUsuario(idUsuario);

      setState(() {
        emprestimos = fetchEmprestimos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        emprestimos = [];
      });
    }
  }

  Material getPage() {
    int totalPages = (emprestimos.length / rowsPerPage).ceil();

    // Calcula o índice inicial e final dos usuários exibidos
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = (startIndex + rowsPerPage) < emprestimos.length
        ? (startIndex + rowsPerPage)
        : emprestimos.length;

    // Seleciona os usuários que serão exibidos na página atual
    List<EmprestimosModel> paginatedEmprestimos =
        emprestimos.sublist(startIndex, endIndex);

    // Lógica para definir os botões de página (máximo 10 botões)
    int startPage = currentPage - 4 < 1 ? 1 : currentPage - 4;
    int endPage = startPage + 8 > totalPages ? totalPages : startPage + 8;
    if (endPage - startPage < 8 && startPage > 1) {
      startPage = endPage - 8 < 1 ? 1 : endPage - 8;
    }

    if (emprestimos.isEmpty) {
      return const Material(
        child: Column(
          children: [
            BreadCrumb(
                breadcrumb: ["Início", "Usuários", "Histórico"],
                icon: Icons.co_present_rounded),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 250, horizontal: 40),
              child: Column(
                children: [
                  Text('Nenhum empréstimo encontrado'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      child: Column(
        children: [
          // Barra de navegação
          const BreadCrumb(
              breadcrumb: ["Início", "Usuários", "Histórico"],
              icon: Icons.co_present_rounded),

          // Corpo da página
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            child: Column(
              children: [
                // Tabela de usuários
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    children: [
                      const Text('Exibir'),
                      DropdownButton<int>(
                        value: rowsPerPage,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              rowsPerPage = value;
                              currentPage =
                                  1; // Reinicia para a primeira página
                            });
                          }
                        },
                        items: rowsPerPageOptions.map((int value) {
                          return DropdownMenuItem<int>(
                              value: value, child: Text(value.toString()));
                        }).toList(),
                      ),
                      const Text(' registros por página'),
                    ],
                  ),
                ),
                Table(
                  border: TableBorder.all(
                      color: const Color.fromARGB(215, 200, 200, 200)),
                  columnWidths: const {
                    0: FlexColumnWidth(0.10), // ID do Exemplar
                    1: FlexColumnWidth(0.35), // Nome do Livro
                    2: FlexColumnWidth(0.15), // Data Empréstimo
                    3: FlexColumnWidth(0.15), // Data Devolução
                    4: FlexColumnWidth(0.15), // Status
                  },
                  children: [
                    // Cabeçalho da tabela
                    const TableRow(
                      decoration:
                          BoxDecoration(color: Color.fromARGB(255, 44, 62, 80)),
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('ID Exemplar',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 15))),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Livro',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Data Empréstimo',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Data Devolução',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Status',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 15)),
                        ),
                      ],
                    ),

                    // Linhas da tabela
                    for (int x = 0; x < paginatedEmprestimos.length; x++)
                      TableRow(
                        decoration: BoxDecoration(
                          color: x % 2 == 0
                              ? const Color.fromRGBO(233, 235, 238, 75)
                              : const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paginatedEmprestimos[x]
                                    .exemplarMap['IdDoExemplarLivro']
                                    .toString(),
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.5),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paginatedEmprestimos[x].exemplarMap['Livro']
                                    ['Titulo'],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.5),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                paginatedEmprestimos[x].dataEmprestimo,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.5),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  paginatedEmprestimos[x].dataDeDevolucao,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.5)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  _getStatusText(
                                      paginatedEmprestimos[x].status),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: _getStatusColor(
                                          paginatedEmprestimos[x].status),
                                      fontSize: 14.5)),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Barra de navegação de páginas
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: currentPage > 1
                            ? () {
                                setState(() {
                                  currentPage--;
                                });
                              }
                            : null,
                      ),
                      for (int i = startPage; i <= endPage; i++)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentPage = i;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: i == currentPage
                                  ? Colors.blueGrey
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                color: i == currentPage
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: currentPage < totalPages
                            ? () {
                                setState(() {
                                  currentPage++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Em Andamento';
      case 2:
        return 'Entregue com Atraso';
      case 3:
        return 'Concluído';
      default:
        return 'Status Desconhecido';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
