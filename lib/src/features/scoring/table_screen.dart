// features/scoring/table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/simple_table_screen.dart';

class TableScreen extends StatelessWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    final isDouble = partie.team1Players.length > 1;
    return isDouble
        ? DoubleTableScreen(partie: partie)
        : SimpleTableScreen(partie: partie);
  }
}
