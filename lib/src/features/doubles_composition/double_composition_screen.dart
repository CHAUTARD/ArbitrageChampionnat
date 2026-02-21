import 'package:flutter/material.dart';

class DoublesCompositionScreen extends StatelessWidget {
  const DoublesCompositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Composition des doubles')),
      body: const Center(
        child: Text(
          "La fonctionnalité de composition des doubles n'est plus disponible.",
        ),
      ),
    );
  }
}
