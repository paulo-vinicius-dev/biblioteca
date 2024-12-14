import 'package:biblioteca/data/models/usuario_model.dart';
import 'package:biblioteca/data/providers/auth_provider.dart';
import 'package:biblioteca/screens/login.dart';
import 'package:biblioteca/screens/tela_emprestimo.dart';
import 'package:biblioteca/screens/telas_testes.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:biblioteca/widgets/forms/form_user.dart';
import 'package:biblioteca/widgets/forms/form_book.dart';
import 'package:biblioteca/widgets/forms/form_author.dart';
import 'package:biblioteca/widgets/tables/author_table_page.dart';
import 'package:biblioteca/widgets/tables/book_table_page.dart';
import 'package:biblioteca/widgets/tables/user_table_page.dart';
import 'package:biblioteca/widgets/navegacao/menu_navegacao.dart';
import 'package:biblioteca/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaPaginaIncial extends StatefulWidget {
  const TelaPaginaIncial({super.key});

  @override
  State<TelaPaginaIncial> createState() => _TelaPaginaIncialState();
}

class _TelaPaginaIncialState extends State<TelaPaginaIncial> {
  String _selectedRoute = '/inicio';

  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;

  void _toggleOverlay(BuildContext context) {
    if (_isExpanded) {
      _overlayEntry?.remove();
      _isExpanded = false;
    } else {
      _overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
              top: kToolbarHeight,
              right: 3,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 240, 241, 247),
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 240, 241, 247),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    height: 140,
                    width: 210,
                    padding: const EdgeInsets.only(top: 15, left: 0),
                    child: ListView(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.settings,
                            size: 21,
                          ),
                          title: const Text(
                            "Configurações",
                            style: TextStyle(fontSize: 12.4),
                          ),
                          onTap: () {
                            _onPageSelected('/configuracoes');
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.logout,
                            size: 21,
                          ),
                          title: const Text("Sair",
                              style: TextStyle(fontSize: 12.4)),
                          onTap: () {
                            _onPageSelected('/sair');
                          },
                        )
                      ],
                    )),
              )));
      Overlay.of(context).insert(_overlayEntry!);
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  void _onPageSelected(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }

  void _sair(context) {
    Navigator.pushNamed(
        context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    // capitalize(nomeDoUsuario);
    return Scaffold(
      body: Row(
        children: [
          MenuNavegacao(onPageSelected: _onPageSelected),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.appBarBackGroundColor,
                actions: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/usericon.png',
                      width: 32,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.usuarioLogado!,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(40, 40, 49, 30)),
                      ),
                      Text(
                        "Admin",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(40, 40, 49, 40)),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  IconButton(
                      onPressed: () {
                        _toggleOverlay(context);
                      },
                      icon: const Icon(
                        Icons.expand_more,
                        color: Color.fromARGB(255, 119, 119, 119),
                      )),
                  const SizedBox(
                    width: 17,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 56),
                  decoration: BoxDecoration(
                      color: AppTheme.drawerBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0)),
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
                          page = const PaginaEmprestimo();
                          break;
                        case '/devolucao':
                          page = const Devolucao();
                          break;
                        case '/autores':
                          page = const AuthorTablePage();
                          break;
                        case '/livros':
                          page = const BookTablePage();
                          break;
                        case '/relatorios':
                          page = const Relatorios();
                          break;
                        case '/nada_consta':
                          page = const NadaConsta();
                          break;
                        case AppRoutes.usuarios:
                          page = const UserTablePage();
                          break;
                        case '/configuracoes':
                          page = const Configuracoes();
                          break;
                        case '/sair':
                          authProvider.logout();
                          _sair(context);
                          page = const TelaLogin();
                          break;
                        case '/novo_usuario':
                          page = const FormUser();
                          break;
                        case AppRoutes.editarUsuario:
                          final user = settings.arguments as Usuario;
                          return MaterialPageRoute(builder: (context) {
                            return FormUser(usuario: user);
                          });
                        case '/novo_autor':
                          page = const FormAutor();
                          break;
                        case '/novo_livro':
                          page = const FormBook();
                          break;
                        default:
                          page = const Home();
                      }
                      return MaterialPageRoute(builder: (_) => page);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
