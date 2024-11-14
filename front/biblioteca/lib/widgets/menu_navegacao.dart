import 'package:flutter/material.dart';
import 'package:biblioteca/models/modelo_menu.dart'; 
import 'package:biblioteca/utils/theme.dart'; 

class MenuNavegacao extends StatefulWidget {
  const MenuNavegacao({super.key});

  @override
  _MenuNavegacaoState createState() => _MenuNavegacaoState();
}

class _MenuNavegacaoState extends State<MenuNavegacao> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<double> _widthAnimation;
  late Animation<double> _labelFadeAnimation;
  final List<AnimationController> _destinationControllers = [];
  final _animationDuration = const Duration(milliseconds: 300);
  bool menuAtivado = false;
  int _expandedIndex = -1; 

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(vsync: this, duration: _animationDuration);

    _widthAnimation = Tween<double>(begin: 70, end: 260).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));

    _labelFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    
    for (var i = 0; i < menuitens.length; i++) {
      _destinationControllers.add(AnimationController(vsync: this, duration: _animationDuration));
    }
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    for (var controller in _destinationControllers) {
      controller.dispose();
    }
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
                    final itemController = _destinationControllers[index];

                    return AnimatedBuilder(
                      animation: itemController,
                      builder: (context, child) {
                        return ExpansionTile(
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
                            setState(() {
                              if (isExpanded) {
                                for (var controller in _destinationControllers) {
                                  controller.reverse();
                                }
                                itemController.forward();
                                _expandedIndex = index;
                              } else if (_expandedIndex == index) {
                                itemController.reverse();
                                _expandedIndex = -1;
                              }
                            });
                          },
                          initiallyExpanded: _expandedIndex == index,
                          title: FadeTransition(
                            opacity: _labelFadeAnimation,
                            child: Visibility(
                              visible: menuAtivado,
                              replacement: const SizedBox.shrink(),
                              child: Text(
                                itemMenu.title,
                                style: TextStyle(
                                  fontSize: 13,
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
                          children: itemMenu.submenus.isNotEmpty
                              ? itemMenu.submenus.map((submenu) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.only(left: 60),
                                    title: Text(
                                      submenu,
                                      style: const TextStyle(fontSize: 12.3),
                                    ),
                                  );
                                }).toList()
                              : [],
                        );
                      },
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
