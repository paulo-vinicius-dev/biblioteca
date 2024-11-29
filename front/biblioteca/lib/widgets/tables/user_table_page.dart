// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:biblioteca/tem_tabela/user_data.dart';
import 'package:biblioteca/tem_tabela/user_model.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserTablePage extends StatefulWidget {
  const UserTablePage({super.key});

  @override
  UserTablePageState createState() => UserTablePageState();
}

class UserTablePageState extends State<UserTablePage> {
  int rowsPerPage = 10; // Quantidade de linhas por página
  final List<int> rowsPerPageOptions = [5, 10, 15, 20];
  int currentPage = 1; // Página atual

  @override
  Widget build(BuildContext context) {
    int totalPages = (users.length / rowsPerPage).ceil();

    // Calcula o índice inicial e final dos usuários exibidos
    int startIndex = (currentPage - 1) * rowsPerPage;
    int endIndex = (startIndex + rowsPerPage) < users.length
        ? (startIndex + rowsPerPage)
        : users.length;

    // Seleciona os usuários que serão exibidos na página atual
    List<User> paginatedUsers = users.sublist(startIndex, endIndex);

    // Lógica para definir os botões de página (máximo 5 botões)
    int startPage = currentPage - 2 < 1 ? 1 : currentPage - 2;
    int endPage = startPage + 4 > totalPages ? totalPages : startPage + 4;
    if (endPage - startPage < 4 && startPage > 1) {
      startPage = endPage - 4 < 1 ? 1 : endPage - 4;
    }

    //Pegar usuarios
    var url = Uri.http('localhost:9090', '/usuario');

    // http
    //     .post(url,
    //         body: jsonEncode({
    //           "IdDaSessao": 6070095939566893115,
    //           "LoginDoUsuarioRequerente": "admin",
    //           "TextoDeBusca": "a"
    //         }))
    //     .then((response) {
    //   var responseLogin = jsonDecode(response.body);
    //
    //   if (response.statusCode == 200 && responseLogin['Aceito']) {
    //   } else if (response.statusCode == 200 && !responseLogin['Aceito']) {}
    // }).catchError((err) {
    //   print('Ops! Ocorreu um erro ao tentar realizar o Login');
    // });

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.novoUsuario);
                },
                label: const Text(
                  'Novo Usuário',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                icon: Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(Colors.green.shade800),
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.all(15.0), // Padding personalizado
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                const Text('Exibir '),
                DropdownButton<int>(
                  value: rowsPerPage,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        rowsPerPage = value;
                        currentPage = 1; // Reinicia para a primeira página
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
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(150), // Largura fixa para a coluna "Nome"
              1: FixedColumnWidth(
                  130), // Largura fixa para a coluna "Matricula"
              2: FixedColumnWidth(
                  180), // Largura fixa para a coluna "Data de Nascimento"
              3: FixedColumnWidth(
                  150), // Largura fixa para a coluna "Tipo de Usuario"
              4: FixedColumnWidth(280), // Largura fixa para a coluna "Opções"
            },
            children: [
              // Cabeçalho da tabela
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Nome', textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Matrícula', textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Data de Nascimento', textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Tipo de Usuario', textAlign: TextAlign.left),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Opções', textAlign: TextAlign.left),
                  ),
                ],
              ),
              // Linhas da tabela
              for (var user in paginatedUsers)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(user.nome, textAlign: TextAlign.left),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(user.matricula, textAlign: TextAlign.left),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child:
                          Text(user.dataNascimento, textAlign: TextAlign.left),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(user.tipoUsuario, textAlign: TextAlign.left),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                                  Icon(Icons.delete, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Excluir',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ]),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 26, 96, 153),
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
                                  Icon(Icons.search, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Vizualizar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ]),
                          ),
                        ],
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
                          color: i == currentPage ? Colors.white : Colors.grey,
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
    );
  }
}
