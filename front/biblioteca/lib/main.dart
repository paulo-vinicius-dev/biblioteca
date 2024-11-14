import 'package:biblioteca/screens/home.dart';
import 'package:biblioteca/screens/login.dart';
import 'package:flutter/material.dart';



void main(){
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x262A4F)),
        fontFamily: "Nunito"
      ),
      home: LoginPage()
    );
  }
}