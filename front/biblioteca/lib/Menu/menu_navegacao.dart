import 'package:flutter/material.dart';
import 'package:sistema_biblioteca/Modelos/modelo_menu.dart';
import 'package:sistema_biblioteca/theme.dart';

class MenuNavegacao extends StatefulWidget {
  const MenuNavegacao({super.key});

  @override
  _MenuNavegacaoState createState() => _MenuNavegacaoState();
}

class _MenuNavegacaoState extends State<MenuNavegacao> with SingleTickerProviderStateMixin {
  double maxwidth = 225.0;
  double minwidth = 70.0;
  bool menuAtivado = false;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final Map<int, bool> _isHovered = {};

  int _selectedIndex = -1; 
  int _expandedIndex = -1; 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 255),
    );

    _widthAnimation = Tween<double>(begin: minwidth, end: maxwidth).animate(_animationController);

    _slideAnimation = Tween<Offset>(begin: const Offset(-0.4, 0), end: const Offset(0, 0))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: -10, end: 1)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  void toggleMenu() {
    setState(() {
      menuAtivado = !menuAtivado;
    });
    if (menuAtivado) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Material(
          elevation: 8.0,
          child: Container(
            width: _widthAnimation.value,
            color: drawerBackgroundColor,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: menuAtivado ? MainAxisAlignment.end : MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: toggleMenu,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildListTile(0, Icons.home, 'Início'),
                      _buildListTile(1, Icons.search, 'Pesquisa Exemplar'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: menuitens.length,
                        itemBuilder: (context, index) {
                          int expansionTileIndex = 1000 + index; 
                          return ExpansionTile(
                            tilePadding: const EdgeInsets.fromLTRB(22, 4, 5, 4),
                            leading: Icon(menuitens[index].icon),
                            backgroundColor: _selectedIndex == expansionTileIndex
                                ? const Color.fromRGBO(233, 235, 238, 75)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            iconColor: selectedColor,
                            textColor: selectedColor,
                            collapsedTextColor: Colors.black87,
                            onExpansionChanged: (isExpanded) {
                              setState(() {
                                if (isExpanded) {
                                  _expandedIndex = index;
                                } else {
                                  _expandedIndex = -1;
                                }
                                _selectedIndex = isExpanded ? expansionTileIndex : -1;
                              });
                            },
                            initiallyExpanded: _expandedIndex == index,
                            title: menuAtivado
                                ? SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _fadeAnimation,
                                      child: Text(
                                        menuitens[index].title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            showTrailingIcon: menuAtivado,
                            
                            children: menuAtivado
                                ? [
                                    for (String item in menuSubItens[index])
                                      ListTile(
                                        contentPadding: const EdgeInsets.only(left: 60),
                                        title: Text(
                                          item,
                                          style: const TextStyle(fontSize: 12.3),

                                          
                                        ),
                                      ),
                                  ]
                                : [],
                          );
                        },
                      ),
                      _buildListTile(100, Icons.settings, 'Configurações'),
                      _buildListTile(101, Icons.exit_to_app, 'Sair'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListTile(int index, IconData icon, String title, {bool isSubItem = false}) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered[index] = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered[index] = false;
        });
      },
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
            _expandedIndex = -1; 
          });
        },
        child: Container(
          color: _selectedIndex == index
              ? const Color.fromRGBO(233, 235, 238, 75) 
              : _isHovered[index] == true
                  ? const Color.fromRGBO(233, 235, 238, 50) 
                  : Colors.transparent,
          child: ListTile(
            contentPadding: isSubItem ? const EdgeInsets.only(left: 50) : const EdgeInsets.fromLTRB(22, 2.5, 5, 2.5),
            leading: Icon(icon, color: Colors.black87),
            title: menuAtivado
                ? SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: isSubItem ? 12 : 13,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
