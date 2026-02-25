import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';

class DoubleTableScreen extends StatelessWidget {
  final Partie partie;
  final List<Player> team1;
  final List<Player> team2;

  const DoubleTableScreen({
    super.key,
    required this.partie,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(context.read()),
      child: Scaffold(
        appBar: AppBar(title: Text(partie.type)),
        body: Center(
          child: Text('Table for ${partie.type}'),
        ),
      ),
    );
  }
}
