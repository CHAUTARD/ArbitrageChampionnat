// Path: lib/src/features/table/table_screen.dart
// Rôle: Écran principal pour l'affichage de la table de jeu.
// Ce widget est un placeholder qui n'est plus activement utilisé.
// Son intention initiale était probablement d'être un point d'entrée pour afficher le tableau des scores, mais cette fonctionnalité a été déplacée ou restructurée.
// Il affiche simplement un message indiquant que la fonctionnalité n'est plus disponible.

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
