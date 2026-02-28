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
//   - "Valider la partie": Bouton pour terminer la partie et enregistrer le résultat final.
// - **Inversion des côtés**: Change automatiquement le côté des équipes sur l'affichage à chaque nouvelle manche pour refléter la réalité du jeu (`areSidesSwapped`).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/scoring/game_state.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:myapp/src/features/scoring/current_manche_score.dart';

/// Previously `ScoringScreen` depended on an ancestor
/// `Provider<GameState>`. To simplify navigation we now create
/// and expose `GameState` internally, so callers can push this
/// widget directly without wrapping it.
class ScoringScreen extends StatefulWidget {
  final Partie partie;
  final List<Player> team1Players;
  final List<Player> team2Players;
  final String arbitreName;

  const ScoringScreen({
    super.key,
    required this.partie,
    required this.team1Players,
    required this.team2Players,
    this.arbitreName = '',
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  late Player _currentServer;
  late Player _tossWinner;

  // hold the GameState instance created for this screen
  late GameState _gameState;

  // allow user to manually flip sides before/during the match
  bool _manualSwap = false;

  @override
  void initState() {
    super.initState();
    _tossWinner = widget.team1Players.first;
    _currentServer = _tossWinner;

    // create our own GameState using the GameService which is expected
    // to be provided at the root of the app (unchanged behaviour)
    _gameState = GameState(context.read());
    _gameState.loadGame(widget.partie);
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
    if (_gameState.game.manches.isEmpty) {
      return false;
    }

    final firstManche = _gameState.game.manches.first;
    final bool firstPointScored =
        firstManche.scoreTeam1 > 0 || firstManche.scoreTeam2 > 0;

    return firstPointScored || _gameState.game.manches.length > 1;
  }

  void _toggleManualSwap() {
    if (gameStateIsStarted()) return;
    setState(() {
      _manualSwap = !_manualSwap;
    });
  }

  void _updateCurrentServer(GameState gameState) {
    // Once first server is defined, it stays the same for the whole manche.
    // Server side is inverted only when moving to the next manche.
    // The displayed server is always the player currently shown on the table
    // for the serving side (first player of that side).
    if (gameState.game.manches.isEmpty) return;
    if (widget.team1Players.isEmpty || widget.team2Players.isEmpty) return;

    final bool isTossWinnerInTeam1 = widget.team1Players.contains(_tossWinner);
    final mancheIndex = gameState.game.manches.length - 1;

    // Displayed sides can be swapped every manche, with an optional manual
    // swap before game start.
    final bool effectiveSwapCurrent = ((mancheIndex % 2) == 1) ^ _manualSwap;
    final bool effectiveSwapFirstManche = _manualSwap;

    // Side of the first server in manche 1 is determined by toss winner side.
    final bool firstServerStartsOnLeft = effectiveSwapFirstManche
        ? !isTossWinnerInTeam1
        : isTossWinnerInTeam1;

    // At the start of each new manche, the first server side alternates.
    bool servingOnLeft = (mancheIndex % 2 == 0)
        ? firstServerStartsOnLeft
        : !firstServerStartsOnLeft;

    final bool servingTeamIsTeam1 = servingOnLeft
        ? !effectiveSwapCurrent
        : effectiveSwapCurrent;

    final Player newServer = servingTeamIsTeam1
        ? widget.team1Players.first
        : widget.team2Players.first;

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

  String? _getDesignatedWinnerId(GameState gameState) {
    const int manchesToWin = 3;
    final int manchesTeam1 = gameState.game.manchesGagneesTeam1;
    final int manchesTeam2 = gameState.game.manchesGagneesTeam2;

    if (manchesTeam1 == manchesTeam2) {
      return null;
    }

    if (manchesTeam1 < manchesToWin && manchesTeam2 < manchesToWin) {
      return null;
    }

    final List<Player> winningTeam = manchesTeam1 > manchesTeam2
        ? widget.team1Players
        : widget.team2Players;

    if (winningTeam.isEmpty) {
      return null;
    }

    return winningTeam.first.id;
  }

  Future<void> _validateAndFinishGame(GameState gameState, String winnerId) async {
    widget.partie.scoreEquipeUn = gameState.game.manchesGagneesTeam1;
    widget.partie.scoreEquipeDeux = gameState.game.manchesGagneesTeam2;
    widget.partie.winnerId = winnerId;
    widget.partie.validated = true;
    _gameState.setGameResult(
      gameState.game.manchesGagneesTeam1,
      gameState.game.manchesGagneesTeam2,
    );

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
    return ChangeNotifierProvider<GameState>.value(
      value: _gameState,
      child: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (gameState.error != null) {
            return Center(child: Text(gameState.error!));
          }

          _updateCurrentServer(gameState);
          final bool isGameStarted = gameStateIsStarted();
          final String? designatedWinnerId = _getDesignatedWinnerId(gameState);
          final bool canValidateGame = designatedWinnerId != null;

          final int mancheIndex = gameState.game.manches.isNotEmpty ? gameState.game.manches.length - 1 : 0;
          final bool areSidesSwapped = (mancheIndex % 2) == 1;

          // determine which team appears on the left; combine automatic
          // swapping per manche with an optional manual override.
          final bool effectiveSwap = areSidesSwapped ^ _manualSwap;
          final List<Player> leftTeam = effectiveSwap ? widget.team2Players : widget.team1Players;
          final List<Player> rightTeam = effectiveSwap ? widget.team1Players : widget.team2Players;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Partie ${widget.partie.numero}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.arbitreName.isNotEmpty)
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sports, size: 18),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.arbitreName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTeamUI(leftTeam, isGameStarted, true),
                        // swap button placed between the two team buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Tooltip(
                            message: 'Changement de côté',
                            child: ElevatedButton(
                              onPressed: isGameStarted ? null : _toggleManualSwap,
                              child: const Icon(Icons.swap_horiz),
                            ),
                          ),
                        ),
                        _buildTeamUI(rightTeam, isGameStarted, false),
                      ],
                    ),
                  ),
                  // diagramme de la table avec joueurs
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildTableDiagram(leftTeam, rightTeam),
                  ),
                  CurrentMancheScore(areSidesSwapped: areSidesSwapped),
                  const SizedBox(height: 20),
                  MancheTable(
                    team1Players: widget.team1Players,
                    team2Players: widget.team2Players,
                  ),
                  if (!widget.partie.validated && canValidateGame) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          _validateAndFinishGame(gameState, designatedWinnerId),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: const Text('Valider la partie'),
                    ),
                  ],
                ],
              ),
            ),
          ));
        },
      ),
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

  // draw a mini diagram representing the table, with top-left and bottom-right players
  Widget _buildTableDiagram(List<Player> team1, List<Player> team2) {
    final String topLeft = team1.isNotEmpty ? team1.first.name : '';
    final String bottomRight = team2.isNotEmpty ? team2.first.name : '';
    // determine if left or right player is currently serving
    bool leftServing = _currentServer == (team1.isNotEmpty ? team1.first : null);
    bool rightServing = _currentServer == (team2.isNotEmpty ? team2.first : null);
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Stack(
        children: [
          // use the provided PNG asset as the table background
          Positioned.fill(
            child: Image.asset(
              'assets/icon/Table.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Row(
              children: [
                Text(topLeft, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (leftServing) ...[
                  const SizedBox(width: 4),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset('assets/icon/Raquette.png', width: 24,
                      key: ValueKey<bool>(leftServing),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (rightServing) ...[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image.asset('assets/icon/Raquette.png', width: 24,
                      key: ValueKey<bool>(rightServing),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(bottomRight, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerButton(Player player, bool isGameStarted, bool isPlayerOnLeft) {
    final bool isServeur = player == _currentServer;
    final onPressed = isGameStarted ? null : () => _selectTossWinner(player);

    final icon = isServeur
        ? Image.asset('assets/icon/Raquette.png', width: 24)
        : const SizedBox(width: 24);
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
