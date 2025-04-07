import 'package:flutter/material.dart';
import 'summary_card.dart';

class SummaryCards extends StatelessWidget {
  final int loansToday;
  final int returnsToday;
  final int delaysToday;
  final VoidCallback onReportsPressed;

  const SummaryCards({
    super.key,
    required this.loansToday,
    required this.returnsToday,
    required this.delaysToday,
    required this.onReportsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SummaryCard(
          title: 'Empréstimos do dia',
          count: loansToday,
          color: Colors.green,
        ),
        SummaryCard(
          title: 'Devoluções do dia',
          count: returnsToday,
          color: Colors.orange,
        ),
        SummaryCard(
          title: 'Empréstimos em Atrasos ',
          count: delaysToday,
          color: Colors.red,
        ),
        SummaryCard(
          title: 'Relatórios',
          icon: Icons.report,
          color: Color.fromARGB(255, 44, 62, 80),
          onPressed: onReportsPressed,
        ),
      ],
    );
  }
}
