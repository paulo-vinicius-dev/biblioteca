import 'package:biblioteca/screens/telas_testes.dart';
import 'package:biblioteca/widgets/menu_navegacao.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';

class TelaPaginaIncial extends StatefulWidget {
  const TelaPaginaIncial({super.key});

  @override
  State<TelaPaginaIncial> createState() => _TelaPaginaIncialState();
}

class _TelaPaginaIncialState extends State<TelaPaginaIncial> {
  String _selectedRoute = '/inicio';

  void _onPageSelected(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: drawerBackgroundColor,
        leading: null,
      ),
      body: Row(
        children: [
          MenuNavegacao(onPageSelected: _onPageSelected),
          Expanded(
            child: Navigator(
              key: GlobalKey<NavigatorState>(),
              initialRoute: _selectedRoute,
              onGenerateRoute: (RouteSettings settings) {
                Widget page;
                switch (settings.name) {
                  case '/inicio':
                    page = const Home();
                    break;
                  case '/pesquisar_livro':
                    page = const PesquisarLivro();
                    break;
                  case '/emprestimo':
                    page = const Emprestimo();
                    break;
                  case '/devolucao':
                    page = const Devolucao();
                    break;
                  case '/autores':
                    page = const Autores();
                    break;
                  case '/livros':
                    page = const Livros();
                    break;
                  case '/relatorios':
                    page = const Relatorios();
                    break;
                  case '/nada_consta':
                    page = const NadaConsta();
                    break;
                  case '/usuarios':
                    page = const Usuarios();
                    break;
                  case '/configuracoes':
                    page = const Configuracoes();
                    break;
                  case '/sair':
                    page = const Login();
                    break;
                  default:
                    page = const Home();
                }
                return MaterialPageRoute(builder: (_) => page);
              },
            ),
          ),
        ],
      ),
    );
  }
}
