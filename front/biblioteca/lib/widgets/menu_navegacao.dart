import 'package:flutter/material.dart';
import 'package:biblioteca/models/modelo_menu.dart'; 
import 'package:biblioteca/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart'; 

class MenuNavegacao extends StatefulWidget {
  const MenuNavegacao({super.key});

  @override
  _MenuNavegacaoState createState() => _MenuNavegacaoState();
}

class _MenuNavegacaoState extends State<MenuNavegacao> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _labelFadeAnimation;
  final _animationDuration = const Duration(milliseconds: 300);
  bool menuAtivado = false;
  int _expandedIndex = -1;

  List<ExpansionTileController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(menuitens.length, (index) => ExpansionTileController());
    _menuAnimationController = AnimationController(vsync: this, duration: _animationDuration);

    _widthAnimation = Tween<double>(begin: 70, end: 260).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));

    _labelFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

  }
  void _handleExpansion(int index, bool isExpanded){
    if(isExpanded){
      setState(() {
        for(int i = 0; i<_controllers.length;i++){
          if( i != index){
            _controllers[i].collapse();
          }
        }
        _expandedIndex = index;
      });
    }else{
      setState(() {
        _expandedIndex = -1;
      });
    }
  }
  @override

  void dispose() {
    _menuAnimationController.dispose();
    super.dispose();
  }

  void onIconPressed() {
    if (menuAtivado) {
      _menuAnimationController.reverse();
    } else {
      _menuAnimationController.forward();
    }

    setState(() {
      menuAtivado = !menuAtivado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _menuAnimationController,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value,
          color: drawerBackgroundColor,
          child: Column(
            children: <Widget>[
              Row(
                
                mainAxisAlignment: menuAtivado ? MainAxisAlignment.end : MainAxisAlignment.center,
                children: [
                  /*Visibility(
                    visible: menuAtivado,
                      replacement: const SizedBox.shrink(),
                      child: SizedBox(
                      child: Image.asset('assets/imagens/logo.png'),
                      width: 150,
                      height: 60,
                      )
                  ),*/
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: onIconPressed,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: menuitens.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _expandedIndex == index;
                    final itemMenu = menuitens[index];
                    

                    return ExpansionTile(
                          controller: _controllers[index],
                          tilePadding: const EdgeInsets.fromLTRB(22, 4, 5, 4),
                          leading: Icon(
                            itemMenu.icon,
                            color: isSelected ? selectedColor : Colors.black87,
                          ),
                          backgroundColor: isSelected
                              ? const Color.fromRGBO(233, 235, 238, 75)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          iconColor: isSelected ? selectedColor : Colors.black87,
                          textColor: isSelected ? selectedColor : Colors.black87,
                          showTrailingIcon: menuAtivado,
                          collapsedTextColor: Colors.black87,
                          onExpansionChanged: (isExpanded) {
                            _handleExpansion(index, isExpanded);
                          },
                          initiallyExpanded: _expandedIndex == index,
                          title: FadeTransition(
                            opacity: _labelFadeAnimation,
                            child: Visibility(
                              visible: menuAtivado,
                              replacement: const SizedBox.shrink(),
                              child: Text(
                                itemMenu.title,
                                style: GoogleFonts.roboto(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w400,
                                  color: isSelected ? selectedColor : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          trailing: itemMenu.submenus.isEmpty
                              ? const SizedBox.shrink()
                              : Icon(
                                  isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                  color: isSelected ? selectedColor : Colors.black87,
                                ),
                          children: itemMenu.submenus.isNotEmpty && menuAtivado
                              ? itemMenu.submenus.map((submenu) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.only(left: 66),
                                    
                                    title: Text(
                                      submenu,
                                      style: GoogleFonts.roboto(fontSize: 12.5),
                                    ),
                                  );
                                }).toList()
                              : [],
                        );
                      
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
