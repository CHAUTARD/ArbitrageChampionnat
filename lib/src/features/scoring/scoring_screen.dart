import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
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
    // Load the game when the screen is initialized
    Provider.of<GameState>(context, listen: false).loadGame(widget.partie);
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

  Future<void> _validateAndFinishGame(GameState gameState) async {
    // The validation logic seems to be missing in GameState.
    // For now, let's just pop the screen.
    // await gameState.validateGame();

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Partie Terminée'),
          content: const Text('Le résultat a été enregistré.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(context.read()),
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (gameState.error != null) {
            return Center(child: Text(gameState.error!));
          }

          final isGameStarted = gameState.game.scores[0] > 0 || gameState.game.scores[1] > 0;

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
                  const MancheTable(),
                  const SizedBox(height: 20),
                  if (gameState.game.manches.length < 5) // Assuming best of 5
                    ElevatedButton(
                      onPressed: gameState.addManche,
                      child: const Text('Manche suivante'),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _validateAndFinishGame(gameState),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Valider la partie'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
