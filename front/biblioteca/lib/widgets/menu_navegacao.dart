import 'package:biblioteca/data/menu_itens.dart';
import 'package:biblioteca/data/providers/menu_provider.dart';
import 'package:biblioteca/utils/assets.dart';
import 'package:flutter/material.dart'; 
import 'package:biblioteca/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MenuNavegacao extends StatefulWidget {
  final ValueChanged<String> onPageSelected;
  
  const MenuNavegacao({super.key, required this.onPageSelected});

  @override
  State<MenuNavegacao> createState() => _MenuNavegacaoState();
}

class _MenuNavegacaoState extends State<MenuNavegacao> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _labelFadeAnimation;
  late Animation<double> _logoFadeAnimation;
  final _animationDuration = const Duration(milliseconds: 300);
  bool menuAtivado = false;
  List<ExpansionTileController> _controllers = [];
  Map<int, int?> selectSubItens = {};
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

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _menuAnimationController, 
      curve: const Interval(0.7, 1.0, curve: Curves.easeInOut)
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
        context.read<MenuState>().expandedIndex = index;
      });
    }else{
      setState(() {
        context.read<MenuState>().expandedIndex = -1;
      });
    }
  }
  void subItensUnselect(index){
    for (var key in selectSubItens.keys){
      if(selectSubItens[key] != selectSubItens[index]){
        selectSubItens[key] = -1;
      }
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

  void _navigateToPage(String? routeName) {
    if(routeName != null){
      widget.onPageSelected(routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expandedIndex = context.watch<MenuState>().expandedIndex;
    return AnimatedBuilder(
      animation: _menuAnimationController,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value,
          color: AppTheme.appBarBackGroundColor,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: menuAtivado ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                children: [
                  if(menuAtivado)
                    Expanded(
                      child: FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: Transform.translate(
                          offset: const Offset(-19, 0),
                          child: SizedBox(
                            width: 200,
                            height:  85,
                            child: Image.asset(AppAssets.logo),
                          ),
                        ),
                      )
                    ),
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
                    bool isSelected = expandedIndex == index;
                    final itemMenu = menuitens[index];
                    return ExpansionTile(
                        controller: _controllers[index],
                        tilePadding: const EdgeInsets.fromLTRB(22, 4, 5, 4),
                        leading: Icon(
                          itemMenu.icon,
                          color: isSelected ? AppTheme.selectedColor(context): Colors.black87,
                        ),
                        backgroundColor: isSelected
                          ? const Color.fromRGBO(233, 235, 238, 75)
                          : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                        iconColor: isSelected ? AppTheme.selectedColor(context) : Colors.black87,
                        textColor: isSelected ? AppTheme.selectedColor(context) : Colors.black87,
                        showTrailingIcon: menuAtivado,
                        collapsedTextColor: Colors.black87,
                        onExpansionChanged: (isExpanded) {
                          if (itemMenu.submenus.isEmpty && isExpanded) {
                            _navigateToPage(itemMenu.route);
                          } else if(itemMenu.submenus.isNotEmpty && isExpanded &&!menuAtivado){
                            onIconPressed();
                          }
                          _handleExpansion(index, isExpanded);
                        },
                        initiallyExpanded: expandedIndex == index,
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
                                color: isSelected ? AppTheme.selectedColor(context) : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        trailing: itemMenu.submenus.isEmpty
                          ? const SizedBox.shrink()
                          : Icon(
                              isSelected ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                              color: isSelected ? AppTheme.selectedColor(context) : Colors.black87,
                            ),
                        children: itemMenu.submenus.isNotEmpty && menuAtivado
                        ? List.generate(itemMenu.submenus.length, (indexSubItem){
                              return ListTile(
                                contentPadding: const EdgeInsets.only(left: 66),
                                title: Text(
                                  itemMenu.submenus[indexSubItem].title,
                                  style: GoogleFonts.roboto(fontSize: 12.5, color: (selectSubItens[index] ==indexSubItem)? AppTheme.selectedColor(context):Colors.black87,)
                                ),
                                onTap: (){
                                  subItensUnselect(index);
                                  selectSubItens[index] = indexSubItem;
                                  _navigateToPage(itemMenu.submenus[indexSubItem].route);
                                },
                              );

                        }): [],
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
