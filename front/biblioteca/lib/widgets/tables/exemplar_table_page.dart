import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para acessar o ExemplarProvider
import 'package:biblioteca/data/models/exemplar_model.dart'; // Certifique-se de que o modelo está correto
import 'package:biblioteca/data/providers/exemplares_provider.dart'; // Supondo que você tenha um provider para buscar exemplares

class ExemplaresPage extends StatefulWidget {
  final String bookName;
  final int idLivro; // Agora recebendo o idLivro

  const ExemplaresPage({
    super.key,
    required this.bookName,
    required this.idLivro, // Recebendo o idLivro
  });

  @override
  State<ExemplaresPage> createState() => _ExemplaresPageState();
}

class _ExemplaresPageState extends State<ExemplaresPage> {
  bool isLoading = true; // Controle de loading

  @override
  void initState() {
    super.initState();
    // Carregar os exemplares ao inicializar a página
    _loadExemplares();
  }

  Future<void> _loadExemplares() async {
    final provider = Provider.of<ExemplarProvider>(context,
        listen: false); // Usando o provider
    await provider.loadExemplares(); // Carregando os exemplares
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Acessando os dados do provider
    final exemplarProvider = Provider.of<ExemplarProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplares - ${widget.bookName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isLoading)
              const CircularProgressIndicator() // Mostra o loading enquanto carrega
            else
              SingleChildScrollView(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(
                        color: const Color.fromARGB(255, 213, 213, 213),
                      ),
                      columnWidths: const {
                        0: IntrinsicColumnWidth(),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: IntrinsicColumnWidth(),
                      },
                      children: [
                        // Cabeçalho da tabela
                        const TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Exemplar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Código Exemplar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Situação',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Estado',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Ações',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        // Linhas da tabela
                        for (int i = 0;
                            i < exemplarProvider.exemplares.length;
                            i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${exemplarProvider.exemplares[i].id}'), // Código Exemplar agora é o id
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(exemplarProvider.exemplares[i].isbn),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: exemplarProvider.exemplares[i].estado
                                      .toString(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      exemplarProvider.exemplares[i] = Exemplar(
                                        id: exemplarProvider.exemplares[i].id,
                                        cativo: exemplarProvider
                                            .exemplares[i].cativo,
                                        statusCodigo: exemplarProvider
                                            .exemplares[i].statusCodigo,
                                        estado: int.parse(newValue ??
                                            '0'), // Convertendo para inteiro
                                        ativo: exemplarProvider
                                            .exemplares[i].ativo,
                                        idLivro: exemplarProvider
                                            .exemplares[i].idLivro,
                                        isbn:
                                            exemplarProvider.exemplares[i].isbn,
                                        titulo: exemplarProvider
                                            .exemplares[i].titulo,
                                        anoPublicacao: exemplarProvider
                                            .exemplares[i].anoPublicacao,
                                        editora: exemplarProvider
                                            .exemplares[i].editora,
                                        idPais: exemplarProvider
                                            .exemplares[i].idPais,
                                        nomePais: exemplarProvider
                                            .exemplares[i].nomePais,
                                        siglaPais: exemplarProvider
                                            .exemplares[i].siglaPais,
                                      );
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: '0',
                                      child: Text('Selecionar'),
                                    ),
                                    DropdownMenuItem(
                                      value: '1',
                                      child: Text('Bom'),
                                    ),
                                    DropdownMenuItem(
                                      value: '2',
                                      child: Text('Danificado'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Adicione a lógica de edição aqui
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 38, 42, 79),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.edit, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text('Editar',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
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
          ],
        ),
      ),
    );
  }
}
