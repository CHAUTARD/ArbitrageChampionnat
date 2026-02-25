import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/game_summary_table.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';

class ScoringScreen extends StatefulWidget {
  final Partie partie;
  final List<Player> team1Players;
  final List<Player> team2Players;

  const ScoringScreen({
    super.key,
    required this.partie,
    required this.team1Players,
    required this.team2Players,
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  late Player serveur;

  @override
  void initState() {
    super.initState();
    serveur = widget.team1Players.first;
  }

  void _toggleServeur(Player joueur) {
    setState(() {
      serveur = joueur;
    });
  }

  void _swapPlayers(List<Player> team) {
    setState(() {
      if (team.length > 1) {
        final temp = team[0];
        team[0] = team[1];
        team[1] = temp;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final bool isGameStarted = gameState.getScore(0) > 0 || gameState.getScore(1) > 0;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlayerButton(widget.team1Players.first, isGameStarted),
                      IconButton(
                        icon: const Icon(Icons.swap_horiz),
                        onPressed: isGameStarted ? null : () => _swapPlayers(widget.team1Players),
                      ),
                      _buildPlayerButton(widget.team2Players.first, isGameStarted),
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.asset('assets/icon/Table.png'),
                    ),
                    Positioned(
                      top: 24,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black54,
                        child: Text(
                          widget.team1Players.first.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.black54,
                        child: Text(
                          widget.team2Players.first.name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreControls(gameState, 0, widget.team1Players.first.id),
                    _buildScoreControls(gameState, 1, widget.team2Players.first.id),
                  ],
                ),
                const SizedBox(height: 20),
                MancheTable(
                  team1Players: widget.team1Players,
                  team2Players: widget.team2Players,
                ),
                const SizedBox(height: 20),
                GameSummaryTable(
                  team1Players: widget.team1Players,
                  team2Players: widget.team2Players,
                ),
                const SizedBox(height: 20),
                // Next Manche Button
                if (gameState.isMancheFinished && !gameState.isGameFinished)
                  ElevatedButton(
                    onPressed: () => gameState.nextManche(),
                    child: const Text('Manche suivante'),
                  ),

                if (gameState.isGameFinished && !gameState.game.partie.validated)
                  ElevatedButton(
                    onPressed: () async {
                      await gameState.validateGame();
                      if (!mounted) return;

                      await showDialog(
                        context: context,
                        barrierDismissible: false, // User must tap button to close
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Partie Validée'),
                            content: const Text(
                                'Veuillez ramener la tablette à la table d\'arbitrage.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (!mounted) return;
                      Navigator.of(context).pop(); // Go back to the match list screen
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Valider le Vainqueur'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildScoreControls(GameState gameState, int teamIndex, String playerId) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () => gameState.decrementScore(teamIndex, playerId),
        ),
        Text(
          '${gameState.getScore(teamIndex)}',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => gameState.incrementScore(teamIndex, playerId),
        ),
      ],
    );
  }

  Widget _buildPlayerButton(Player player, bool isGameStarted) {
    final bool isServeur = player == serveur;
    return ElevatedButton.icon(
      onPressed: isGameStarted ? null : () => _toggleServeur(player),
      icon: isServeur ? Image.asset('assets/icon/Raquette.png', width: 24) : const SizedBox(width: 24),
      label: Text(player.name),
    );
  }
}
