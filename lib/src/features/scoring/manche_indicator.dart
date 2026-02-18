import 'package:flutter/material.dart';

class MancheIndicator extends StatelessWidget {
  final int manchesGagneesTeam1;
  final int manchesGagneesTeam2;
  final bool isSideSwapped;

  const MancheIndicator({
    super.key,
    required this.manchesGagneesTeam1,
    required this.manchesGagneesTeam2,
    this.isSideSwapped = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget team1Manches = _buildMancheCounter(
        context, manchesGagneesTeam1, theme.primaryColor);
    Widget team2Manches = _buildMancheCounter(
        context, manchesGagneesTeam2, theme.colorScheme.error);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: isSideSwapped
          ? [
              Expanded(child: team2Manches),
              Expanded(child: team1Manches),
            ]
          : [
              Expanded(child: team1Manches),
              Expanded(child: team2Manches),
            ],
    );
  }

  Widget _buildMancheCounter(
      BuildContext context, int count, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'MANCHES',
          style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'Oswald', fontWeight: FontWeight.bold),
        ),
        Text(
          '$count/3',
          style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Oswald', color: color),
        ),
      ],
    );
  }
}
