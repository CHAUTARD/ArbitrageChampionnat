// Path: lib/src/features/scoring/scoring_screen.dart

// Rôle: Écran principal pour le comptage des points d'une partie.
// C'est l'interface où l'utilisateur interagit pour enregistrer les scores.
//
// Fonctionnalités:
// - **Gestion de l'état du jeu**: S'intègre avec `GameState` (via Provider) pour charger, afficher et mettre à jour l'état de la partie.
// - **Affichage des équipes**: Montre les joueurs des deux équipes. Avant que la partie ne commence, 
//   il permet d'échanger la position des joueurs dans un double.
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
import 'package:myapp/src/features/scoring/card_management_panel.dart';
import 'package:myapp/src/features/scoring/card_sanction_service.dart';

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

class _ScoringScreenState extends State<ScoringScreen>
    with SingleTickerProviderStateMixin {
  static const double _tableCardWidth = 40;
  static const double _tableCardHeight = 60;
  static const double _tableCardTopAnchor = 30;
  static const double _whiteCardSideInset = 40;
  static const double _cardsHorizontalGap = 6;
  static const double _leftWhiteCardVerticalOffset = 20;
  static const double _rightWhiteCardVerticalOffset = -20;

  late Player _currentServer;
  late Player _tossWinner;
  late AnimationController _racketAnimationController;
  late Animation<double> _racketScaleAnimation;

  // hold the GameState instance created for this screen
  late GameState _gameState;

  // allow user to manually flip sides before/during the match
  bool _manualSwap = false;
  bool _showWhiteCardOnTable = false;
  bool _whiteByTeam1 = false;
  bool _whiteByTeam2 = false;
  final CardSanctionService _cardSanctionService = CardSanctionService();
  Map<String, PlayerPersistentCards> _persistentCardsByPlayer = {};

  @override
  void initState() {
    super.initState();
    _tossWinner = widget.team1Players.first;
    _currentServer = _tossWinner;
    _racketAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _racketScaleAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(
        parent: _racketAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // create our own GameState using the GameService which is expected
    // to be provided at the root of the app (unchanged behaviour)
    _gameState = GameState(context.read());
    _gameState.loadGame(widget.partie);
    _loadWhiteCardState();
    _loadPersistentCardsState();
  }

  Future<void> _loadWhiteCardState() async {
    final partieId = widget.partie.id;
    if (partieId == null) return;
    final hasAnyWhite = await _cardSanctionService.hasAnyWhiteInPartie(partieId);
    final whiteByTeam = await _cardSanctionService.getWhiteByTeam(
      partieId: partieId,
      team1PlayerIds: widget.partie.team1PlayerIds,
      team2PlayerIds: widget.partie.team2PlayerIds,
      isDouble: widget.partie.isDouble,
    );
    if (!mounted) return;
    setState(() {
      _showWhiteCardOnTable = hasAnyWhite;
      _whiteByTeam1 = whiteByTeam['team1'] == true;
      _whiteByTeam2 = whiteByTeam['team2'] == true;
    });
  }

  void _onWhiteCardStateChanged(bool hasAnyWhite) {
    if (!mounted) return;
    setState(() {
      _showWhiteCardOnTable = hasAnyWhite;
    });
  }

  void _onWhiteByTeamChanged(Map<String, bool> whiteByTeam) {
    if (!mounted) return;
    setState(() {
      _whiteByTeam1 = whiteByTeam['team1'] == true;
      _whiteByTeam2 = whiteByTeam['team2'] == true;
    });
  }

  Future<void> _loadPersistentCardsState() async {
    final playerIds = [
      ...widget.team1Players.map((player) => player.id),
      ...widget.team2Players.map((player) => player.id),
    ];
    final state = await _cardSanctionService.getPlayersPersistentCards(playerIds);
    if (!mounted) return;
    setState(() {
      _persistentCardsByPlayer = state;
    });
  }

  void _onPersistentCardsChanged(Map<String, PlayerPersistentCards> state) {
    if (!mounted) return;
    setState(() {
      _persistentCardsByPlayer = state;
    });
  }

  @override
  void dispose() {
    _racketAnimationController.dispose();
    super.dispose();
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
    // The displayed server follows table-tennis service alternation rules:
    // - every 2 points normally
    // - every point from 10-10.
    // We map the serving side to the currently displayed left/right players.
    if (gameState.game.manches.isEmpty) return;
    if (widget.team1Players.isEmpty || widget.team2Players.isEmpty) return;

    final bool isTossWinnerInTeam1 = widget.team1Players.contains(_tossWinner);
    final mancheIndex = gameState.game.manches.length - 1;
    final currentManche = gameState.game.manches[mancheIndex];
    final totalPoints = currentManche.scoreTeam1 + currentManche.scoreTeam2;

    // Displayed sides can be swapped every manche, with an optional manual
    // swap before game start.
    final bool effectiveSwapCurrent = ((mancheIndex % 2) == 1) ^ _manualSwap;

    // Side of first service in this displayed configuration.
    final bool firstServerStartsOnLeft = effectiveSwapCurrent
      ? !isTossWinnerInTeam1
      : isTossWinnerInTeam1;

    final bool isDeucePhase =
      currentManche.scoreTeam1 >= 10 && currentManche.scoreTeam2 >= 10;
    final int serviceTurn = isDeucePhase ? totalPoints : (totalPoints ~/ 2);
    final bool servingOnLeft =
      serviceTurn.isEven ? firstServerStartsOnLeft : !firstServerStartsOnLeft;

    final Player displayedLeftPlayer = effectiveSwapCurrent
        ? widget.team2Players.first
        : widget.team1Players.first;

    final Player displayedRightPlayer = effectiveSwapCurrent
        ? widget.team1Players.first
        : widget.team2Players.first;

    final Player newServer = servingOnLeft
      ? displayedLeftPlayer
      : displayedRightPlayer;

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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isSmallScreen = constraints.maxWidth < 520;

                        if (isSmallScreen) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildTeamUI(leftTeam, isGameStarted, true),
                                  _buildTeamUI(rightTeam, isGameStarted, false),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildCenterSwapButton(isGameStarted),
                            ],
                          );
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTeamUI(leftTeam, isGameStarted, true),
                            _buildCenterSwapButton(isGameStarted),
                            _buildTeamUI(rightTeam, isGameStarted, false),
                          ],
                        );
                      },
                    ),
                  ),
                  // diagramme de la table avec joueurs
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildTableDiagram(leftTeam, rightTeam),
                  ),
                  CurrentMancheScore(areSidesSwapped: areSidesSwapped),
                  const SizedBox(height: 12),
                  CardManagementPanel(
                    partie: widget.partie,
                    team1Players: widget.team1Players,
                    team2Players: widget.team2Players,
                    onWhiteCardStateChanged: _onWhiteCardStateChanged,
                    onWhiteByTeamChanged: _onWhiteByTeamChanged,
                    onPersistentCardsChanged: _onPersistentCardsChanged,
                  ),
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

  Widget _buildCenterSwapButton(bool isGameStarted) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Tooltip(
        message: 'Changement de côté',
        child: ElevatedButton(
          onPressed: isGameStarted ? null : _toggleManualSwap,
          child: const Icon(Icons.swap_horiz),
        ),
      ),
    );
  }

  Widget _buildTeamUI(List<Player> team, bool isGameStarted, bool isPlayerOnLeft) {
    final player = team.first;
    final playerButton = Flexible(
      child: _buildPlayerButton(player, isGameStarted, isPlayerOnLeft),
    );

    final children = [
      playerButton,
      if (team.length > 1)
        IconButton(
          icon: const Icon(Icons.swap_horiz),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 30, height: 30),
          visualDensity: VisualDensity.compact,
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
    final Player? topLeftPlayer = team1.isNotEmpty ? team1.first : null;
    final Player? bottomRightPlayer = team2.isNotEmpty ? team2.first : null;
    final String topLeft = topLeftPlayer?.name ?? '';
    final String bottomRight = bottomRightPlayer?.name ?? '';
    final topLeftCards = topLeftPlayer == null
      ? const PlayerPersistentCards()
      : (_persistentCardsByPlayer[topLeftPlayer.id] ??
        const PlayerPersistentCards());
    final bottomRightCards = bottomRightPlayer == null
      ? const PlayerPersistentCards()
      : (_persistentCardsByPlayer[bottomRightPlayer.id] ??
        const PlayerPersistentCards());
    // determine if left or right player is currently serving
    bool leftServing = _currentServer == (team1.isNotEmpty ? team1.first : null);
    bool rightServing = _currentServer == (team2.isNotEmpty ? team2.first : null);
    final bool leftTeamIsTeam1 = identical(team1, widget.team1Players);
    final bool rightTeamIsTeam1 = identical(team2, widget.team1Players);
    final bool leftWhite = leftTeamIsTeam1 ? _whiteByTeam1 : _whiteByTeam2;
    final bool rightWhite = rightTeamIsTeam1 ? _whiteByTeam1 : _whiteByTeam2;
    final String? leftColoredCardAsset = _getHighestPersistentCardAsset(topLeftCards);
    final String? rightColoredCardAsset = _getHighestPersistentCardAsset(bottomRightCards);
    final bool hasLeftWhiteVisible = _showWhiteCardOnTable && leftWhite;
    final bool hasRightWhiteVisible = _showWhiteCardOnTable && rightWhite;
    final double leftColoredInset = _whiteCardSideInset +
      (hasLeftWhiteVisible ? _tableCardWidth + _cardsHorizontalGap : 0);
    final double rightColoredInset = _whiteCardSideInset +
      (hasRightWhiteVisible ? _tableCardWidth + _cardsHorizontalGap : 0);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        topLeft,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (leftServing) ...[
                      const SizedBox(width: 4),
                      _buildAnimatedRacket(),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (rightServing) ...[
                      _buildAnimatedRacket(),
                      const SizedBox(width: 4),
                    ],
                    SizedBox(
                      width: 120,
                      child: Text(
                        bottomRight,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showWhiteCardOnTable && leftWhite)
            Positioned(
              top: _tableCardTopAnchor + _leftWhiteCardVerticalOffset,
              left: _whiteCardSideInset,
              child: IgnorePointer(
                child: _buildWhiteTableCard(),
              ),
            ),
          if (_showWhiteCardOnTable && rightWhite)
            Positioned(
              top: _tableCardTopAnchor + _rightWhiteCardVerticalOffset,
              right: _whiteCardSideInset,
              child: IgnorePointer(
                child: _buildWhiteTableCard(),
              ),
            ),
          if (leftColoredCardAsset != null)
            Positioned(
              top: _tableCardTopAnchor + _leftWhiteCardVerticalOffset,
              left: leftColoredInset,
              child: IgnorePointer(
                child: _buildHeaderCardIcon(leftColoredCardAsset),
              ),
            ),
          if (rightColoredCardAsset != null)
            Positioned(
              top: _tableCardTopAnchor + _rightWhiteCardVerticalOffset,
              right: rightColoredInset,
              child: IgnorePointer(
                child: _buildHeaderCardIcon(rightColoredCardAsset),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWhiteTableCard() {
    return Container(
      width: _tableCardWidth,
      height: _tableCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: Image.asset(
          'assets/icon/Blanc.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildAnimatedRacket() {
    return ScaleTransition(
      scale: _racketScaleAnimation,
      child: Image.asset('assets/icon/Raquette.png', width: 24),
    );
  }

  Widget _buildPlayerButton(Player player, bool isGameStarted, bool isPlayerOnLeft) {
    final bool isServeur = player == _currentServer;
    final onPressed = isGameStarted ? null : () => _selectTossWinner(player);

    final icon = isServeur
        ? Image.asset('assets/icon/Raquette.png', width: 24)
        : const SizedBox(width: 24);
    final label = SizedBox(
      width: 74,
      child: Text(
        player.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

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

  Widget _buildHeaderCardIcon(String assetPath) {
    return Container(
      width: _tableCardWidth,
      height: _tableCardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  bool _hasAnyPersistentCard(PlayerPersistentCards cards) {
    return cards.yellow || cards.yellowRedPlus || cards.red;
  }

  Widget _buildTableCardsRow(PlayerPersistentCards cards) {
    final String? highestCardAsset = _getHighestPersistentCardAsset(cards);
    if (highestCardAsset == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderCardIcon(highestCardAsset),
      ],
    );
  }

  String? _getHighestPersistentCardAsset(PlayerPersistentCards cards) {
    if (cards.red) return 'assets/icon/Rouge.png';
    if (cards.yellowRedPlus) return 'assets/icon/Orange.png';
    if (cards.yellow) return 'assets/icon/Jaune.png';
    return null;
  }
}
