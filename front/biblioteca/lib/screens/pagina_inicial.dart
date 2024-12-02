import 'package:biblioteca/screens/tela_emprestimo.dart';
import 'package:biblioteca/screens/telas_testes.dart';
import 'package:biblioteca/utils/routes.dart';
import 'package:biblioteca/widgets/forms/form_usuario.dart';
import 'package:biblioteca/widgets/tables/user_table_page.dart';
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
  
  bool _isExpanded = false;
  OverlayEntry? _overlayEntry;

  void _toggleOverlay(BuildContext context){
    if(_isExpanded){
      _overlayEntry?.remove();
      _isExpanded = false;
    }else{
      _overlayEntry = OverlayEntry(builder: (context)=>
        Positioned(
          top:kToolbarHeight,
          right: 3,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 240, 241, 247),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 241, 247),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
              ),
              height: 140,
              width: 210,
              padding: EdgeInsets.only(top: 15, left: 0),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings,size: 21,),
                    title: Text("Configurações", style: TextStyle(fontSize: 12.4),),
                    onTap: (){
                      _onPageSelected('/configuracoes');
                    },
                  ),
                  SizedBox(height: 8,),
                  ListTile(
                    leading: Icon(Icons.logout, size: 21,),
                    title: Text("Sair", style: TextStyle(fontSize: 12.4)),
                    onTap: (){
                      _onPageSelected('/sair');
                    },
                  )
                ],
              )
            ),
          )
        )
      );
      Overlay.of(context)?.insert(_overlayEntry!);
      _isExpanded = true;
    }
  }
  @override
  void dispose(){
    _overlayEntry?.remove();
    super.dispose();
  }
  void _onPageSelected(String route) {
    setState(() {
      _selectedRoute = route;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MenuNavegacao(onPageSelected: _onPageSelected),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppTheme.appBarBackGroundColor,
                actions:[
                  ClipOval(
                    child: Image.asset('assets/images/usericon.png',
                    width: 32,
                    fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Elena M.", style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(40, 40, 49, 30)
                        ),
                      ),
                      Text("Admin", style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(40, 40, 49, 40)
                        ),
                      )
                  ],
                  ),
                  SizedBox(
                    width: 16,
                  ),  
                  IconButton(
                    onPressed: (){
                      _toggleOverlay(context);
                    }, 
                    icon: Icon( 
                    Icons.expand_more,
                      color: const Color.fromARGB(255, 119, 119, 119),
                    )
                  ),
                  SizedBox(width: 17,)
                ],
              ),
              body: Container(
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
                      case AppRoutes.usuarios:
                        page = const UserTablePage();
                        break;
                      case '/configuracoes':
                        page = const Configuracoes();
                        break;
                      case '/sair':
                        page = const Login();
                        break;
                      case '/novo_usuario':
                        page = const FormUsuario();
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
        ],
      ),
    );
  }
}
