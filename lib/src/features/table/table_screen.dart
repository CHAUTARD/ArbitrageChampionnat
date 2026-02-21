import 'package:flutter/material.dart';

class TableScreen extends StatelessWidget {
  const TableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau des scores')),
      body: const Center(
        child: Text(
          "La fonctionnalité de tableau des scores n'est plus disponible.",
        ),
      ),
    );
  }
}
