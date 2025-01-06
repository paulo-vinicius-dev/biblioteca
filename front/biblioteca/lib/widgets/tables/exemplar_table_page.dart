import 'package:flutter/material.dart';
import 'package:biblioteca/tem_tabela/exemplar_model.dart';

class ExemplaresPage extends StatefulWidget {
  final String bookName;
  final List<Exemplar> exemplares;

  const ExemplaresPage({
    super.key,
    required this.bookName,
    required this.exemplares,
  });

  @override
  State<ExemplaresPage> createState() => _ExemplaresPageState();
}

class _ExemplaresPageState extends State<ExemplaresPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplares - ${widget.bookName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                                'Nome',
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
                                'Estado Físico',
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
                        for (int i = 0; i < widget.exemplares.length; i++)
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('000${i + 1}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.exemplares[i].nomePai),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: widget.exemplares[i].situacao,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.exemplares[i] = Exemplar(
                                        nomePai: widget.exemplares[i].nomePai,
                                        situacao: newValue ?? '',
                                        estado: widget.exemplares[i].estado,
                                      );
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Emprestado',
                                      child: Text('Emprestado'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Reservado',
                                      child: Text('Reservado'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Disponivel',
                                      child: Text('Disponivel'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Indisponivel',
                                      child: Text('Indisponivel'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: widget.exemplares[i].estado,
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.exemplares[i] = Exemplar(
                                        nomePai: widget.exemplares[i].nomePai,
                                        situacao: widget.exemplares[i].situacao,
                                        estado: newValue ?? '',
                                      );
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Bom',
                                      child: Text('Bom'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Danificado',
                                      child: Text('Danificado'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Selecionar',
                                      child: Text('Selecionar'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    //salvar
                                  },
                                  child: const Text('Salvar'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
