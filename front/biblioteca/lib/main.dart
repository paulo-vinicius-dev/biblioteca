import 'package:flutter/material.dart';
import 'package:biblioteca/pag_inicial.dart';



void main(){
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto'
      ),
      home: const PaginaIncial(),
    );
  }
}