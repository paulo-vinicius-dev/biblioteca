import 'package:biblioteca/widgets/bread_crumb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginaEmprestimo extends StatefulWidget {
  const PaginaEmprestimo({super.key});

  @override
  State<PaginaEmprestimo> createState() => _PaginaEmprestimoState();
}

class _PaginaEmprestimoState extends State<PaginaEmprestimo> {
  @override
  Widget build(BuildContext context) {
    return 
       Material(
            child: Column(
              children: [
                const BreadCrumb(breadcrumb: ['Início', 'Empréstimo'], icon: Icons.my_library_books_rounded,),
                Padding(
                  padding: EdgeInsets.only(top: 40,left: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pesquisa De Aluno", 
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      SizedBox(height: 40,),
                      Row(
                        children: [
                          SizedBox(
                            width: 800,
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: "Insira os dados do aluno",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)
                                )
                              ),
                            ),
                          ),
                          SizedBox(width: 30,),
                          ElevatedButton(
                            style:ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              backgroundColor: Color.fromRGBO(38, 42, 79, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                              )
                            ),
                            child: Text("Pesquisar", style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                              )
                            ),
                            onPressed: (){
                            }, 
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
       );
    
  }
}