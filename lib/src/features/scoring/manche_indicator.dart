import 'package:flutter/material.dart';

class MancheIndicator extends StatelessWidget {
  final int manchesGagnantes;
  final int manchesPerdues;

  const MancheIndicator({
    super.key,
    required this.manchesGagnantes,
    required this.manchesPerdues,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is now empty and will not display anything.
    return const SizedBox.shrink();
  }
}
