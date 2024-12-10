import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/services/usuario_service.dart';
import 'package:biblioteca/widgets/bread_crumb.dart';
import 'package:flutter/material.dart';

class PaginaEmprestimo extends StatefulWidget {
  const PaginaEmprestimo({super.key});

  @override
  State<PaginaEmprestimo> createState() => _PaginaEmprestimoState();
}

class _PaginaEmprestimoState extends State<PaginaEmprestimo> {
  final UsuarioService usuarioService = UsuarioService(); // Instância do serviço de usuários
  
  late Future<UsuariosAtingidos> _usuarios; // Alterado para o tipo correto
  TextEditingController _searchController = TextEditingController(); // Controlador para o campo de pesquisa
  String _searchQuery = ''; // Variável para armazenar a pesquisa

  @override
  void initState() {
    super.initState();
    _usuarios = usuarioService.fetchUsuarios(1, 'usuario_requerente'); // Exemplo de idDaSessao e login
  }

  // Função para buscar os usuários de acordo com o texto da pesquisa
  void _searchUsuarios() {
    setState(() {
      _searchQuery = _searchController.text; // Atualiza a variável com o texto digitado
      // Atualiza a lista de usuários com a pesquisa
      _usuarios = usuarioService.fetchUsuarios(1, 'usuario_requerente'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          BreadCrumb(breadcrumb: ['Início', 'Empréstimo'], icon: Icons.my_library_books_rounded),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pesquisa De Aluno",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(
                      width: 800,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            labelText: "Insira os dados do aluno",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          backgroundColor: const Color.fromRGBO(38, 42, 79, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text("Pesquisar",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16)),
                      onPressed: _searchUsuarios, // Chama a função para realizar a pesquisa
                    )
                  ],
                ),
                const SizedBox(height: 40),
                // Usando FutureBuilder para exibir os usuários
                FutureBuilder<UsuariosAtingidos>(
                  future: _usuarios,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null || snapshot.data!.usuarioAtingidos == null || snapshot.data!.usuarioAtingidos!.isEmpty) {
                      return const Center(child: Text('Nenhum usuário encontrado.'));
                    } else {
                      final usuarios = snapshot.data!.usuarioAtingidos!;
                      // Filtra os usuários com base na pesquisa
                      final filteredUsuarios = usuarios.where((usuario) {
                        return (usuario.nome?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) ||
                               (usuario.email?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) ||
                               (usuario.telefone?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase());
                      }).toList();
                      
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredUsuarios.length,
                        itemBuilder: (context, index) {
                          final usuario = filteredUsuarios[index];
                          return ListTile(
                            title: Text(usuario.nome ),
                            subtitle: Text(usuario.email ),
                            trailing: Text(usuario.telefone ?? 'Sem número'),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
