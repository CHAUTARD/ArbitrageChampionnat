// Path: lib/src/features/scoring/scoring_screen.dart
// Rôle: Écran principal pour le comptage des points d'une partie.
// C'est l'interface où l'utilisateur interagit pour enregistrer les scores.
//
// Fonctionnalités:
// - **Gestion de l'état du jeu**: S'intègre avec `GameState` (via Provider) pour charger, afficher et mettre à jour l'état de la partie.
// - **Affichage des équipes**: Montre les joueurs des deux équipes. Avant que la partie ne commence, il permet d'échanger la position des joueurs dans un double.
// - **Sélection du serveur**: Permet de désigner le joueur qui a gagné le tirage au sort (toss) et qui servira en premier.
// - **Logique de service**: Calcule et met à jour automatiquement le joueur qui doit servir (`_currentServer`) en fonction du score, de la manche et du vainqueur du toss, en suivant les règles du tennis de table (changement de service tous les 2 points, etc.).
// - **Score de la manche en cours**: Affiche et permet de modifier le score de la manche actuelle via le widget `CurrentMancheScore`.
// - **Tableau des manches**: Affiche un résumé des scores de toutes les manches jouées via `MancheTable`.
// - **Contrôles de la partie**:
//   - "Manche suivante": Bouton pour conclure la manche en cours et en commencer une nouvelle.
//   - "Valider la partie": Bouton pour terminer la partie et enregistrer le résultat final.
// - **Inversion des côtés**: Change automatiquement le côté des équipes sur l'affichage à chaque nouvelle manche pour refléter la réalité du jeu (`areSidesSwapped`).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:myapp/src/features/scoring/current_manche_score.dart';

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
  late Player _currentServer;
  late Player _tossWinner;

  @override
  void initState() {
    super.initState();
    _tossWinner = widget.team1Players.first;
    _currentServer = _tossWinner;
    Provider.of<GameState>(context, listen: false).loadGame(widget.partie);
  }

  void _selectTossWinner(Player player) {
    if (gameStateIsStarted()) return;
    setState(() {
      _tossWinner = player;
      _currentServer = player;
    });
  }

  void _swapPlayers(List<Player> team) {
    if (gameStateIsStarted()) return;
    setState(() {
      if (team.length > 1) {
        final temp = team[0];
        team[0] = team[1];
        team[1] = temp;
      }
    });
  }

  bool gameStateIsStarted() {
      final gameState = Provider.of<GameState>(context, listen: false);
      return gameState.game.scores[0] > 0 || gameState.game.scores[1] > 0;
  }

  void _updateCurrentServer(GameState gameState) {
    if (gameState.game.manches.isEmpty) return;

    final bool isTossWinnerInTeam1 = widget.team1Players.contains(_tossWinner);
    final Player tossLoser = isTossWinnerInTeam1
        ? widget.team2Players.first
        : widget.team1Players.first;

    final mancheIndex = gameState.game.manches.length - 1;
    final currentManche = gameState.game.manches.last;
    final totalScore = currentManche.scoreTeam1 + currentManche.scoreTeam2;

    Player setInitialServer;
    Player setInitialReceiver;
    final bool isTossWinnerServingSet = (mancheIndex % 2 == 0);

    if (isTossWinnerServingSet) {
      setInitialServer = _tossWinner;
      setInitialReceiver = tossLoser;
    } else {
      setInitialServer = tossLoser;
      setInitialReceiver = _tossWinner;
    }

    int serviceChanges;
    if (totalScore >= 20) {
      const int changesBeforeDeuce = 10; // 20 / 2
      serviceChanges = changesBeforeDeuce + (totalScore - 20);
    } else {
      serviceChanges = totalScore ~/ 2;
    }

    final Player newServer = (serviceChanges % 2 == 0) ? setInitialServer : setInitialReceiver;

    if (_currentServer != newServer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentServer = newServer;
          });
        }
      });
    }
  }

  Future<void> _validateAndFinishGame(GameState gameState) async {
    if (!mounted) return;
    await showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Partie Terminée'),
            content: const Text('Le résultat a été enregistré.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          );
        });
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (gameState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (gameState.error != null) {
          return Center(child: Text(gameState.error!));
        }

        _updateCurrentServer(gameState);
        final bool isGameStarted = gameStateIsStarted();

        final int mancheIndex = gameState.game.manches.isNotEmpty ? gameState.game.manches.length - 1 : 0;
        final bool areSidesSwapped = (mancheIndex % 2) == 1;

        final List<Player> leftTeam = areSidesSwapped ? widget.team2Players : widget.team1Players;
        final List<Player> rightTeam = areSidesSwapped ? widget.team1Players : widget.team2Players;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      _buildTeamUI(leftTeam, isGameStarted, true),
                      _buildTeamUI(rightTeam, isGameStarted, false),
                    ],
                  ),
                ),
                CurrentMancheScore(areSidesSwapped: areSidesSwapped),
                const SizedBox(height: 20),
                MancheTable(
                  team1Players: widget.team1Players,
                  team2Players: widget.team2Players,
                ),
                const SizedBox(height: 20),
                if (gameState.game.manches.length < 5)
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
    );
  }

  Widget _buildTeamUI(List<Player> team, bool isGameStarted, bool isPlayerOnLeft) {
    final player = team.first;
    final children = [
      _buildPlayerButton(player, isGameStarted, isPlayerOnLeft),
      if (team.length > 1)
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          tooltip: 'Changer la position des joueurs',
          onPressed: isGameStarted ? null : () => _swapPlayers(team),
        ),
    ];

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Reverse order for the right side player to keep button near the center
        children: isPlayerOnLeft ? children : children.reversed.toList(),
      ),
    );
  }

  Widget _buildPlayerButton(Player player, bool isGameStarted, bool isPlayerOnLeft) {
    final bool isServeur = player == _currentServer;
    final onPressed = isGameStarted ? null : () => _selectTossWinner(player);

    final icon = isServeur ? Image.asset('assets/icon/Raquette.png', width: 24) : const SizedBox(width: 24);
    final label = Text(player.name);

    final children = isPlayerOnLeft
        ? <Widget>[label, const SizedBox(width: 8), icon]
        : <Widget>[icon, const SizedBox(width: 8), label];

    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
