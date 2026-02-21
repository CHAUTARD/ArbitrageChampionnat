import 'package:flutter/material.dart';
import 'package:myapp/models/partie_model.dart';

class ScoringScreen extends StatelessWidget {
  final Partie partie;

  const ScoringScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("La fonctionnalité de scoring n'est plus disponible."),
    );
  }
}
