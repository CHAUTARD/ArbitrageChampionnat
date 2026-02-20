// features/table/table_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';

class TableScreen extends ConsumerStatefulWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  ConsumerState<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends ConsumerState<TableScreen> {
  bool _isDialogShown = false;
  bool _showCartons = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(matchProvider.notifier).startMatch(widget.partie);
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchProvider);
    final matchNotifier = ref.read(matchProvider.notifier);

    ref.listen<MatchState>(matchProvider, (previous, next) {
      if (next.isMatchFinished && !_isDialogShown) {
        _showEndGameDialog(context);
        setState(() {
          _isDialogShown = true;
        });
      }
    });

    final isDouble = widget.partie.team1Players.length > 1;
    final theme = Theme.of(context);

    final String title;
    if (isDouble) {
      title = 'Double';
    } else {
      title =
          '${widget.partie.team1Players.first.name} vs ${widget.partie.team2Players.first.name}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Partie #${widget.partie.id}',
                style:
                    theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 20)),
            Text(title,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withAlpha(204)))
          ],
        ),
        centerTitle: true,
        toolbarHeight: 65,
        actions: [
          if (!isDouble)
            IconButton(
              icon: Icon(_showCartons ? Icons.style : Icons.style_outlined),
              tooltip: 'Afficher/Masquer les cartons',
              onPressed: () {
                setState(() {
                  _showCartons = !_showCartons;
                });
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Manche ${matchState.manche}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontFamily: 'Oswald', fontSize: 20)),
            const SizedBox(height: 16),
            _buildPlayersRow(context, matchState, matchNotifier, isDouble),
            const SizedBox(height: 16),
            _buildPingPongTable(context),
            const SizedBox(height: 16),
            _buildScoresRow(context, matchState, matchNotifier),
            const SizedBox(height: 16),
            if (_showCartons && !isDouble)
              _buildActionsRow(context, matchState, matchNotifier),
            const MancheTable(),
          ],
        ),
      ),
    );
  }

  void _showEndGameDialog(BuildContext context) {
    final matchState = ref.read(matchProvider);
    final winnerTeamNumber = matchState.winnerTeam;
    final theme = Theme.of(context);
    final isDouble = widget.partie.team1Players.length > 1;

    final String winnerName;
    if (winnerTeamNumber == 1) {
      winnerName = isDouble
          ? '${widget.partie.team1Players[0].name} & ${widget.partie.team1Players[1].name}'
          : widget.partie.team1Players.first.name;
    } else {
      winnerName = isDouble
          ? '${widget.partie.team2Players[0].name} & ${widget.partie.team2Players[1].name}'
          : widget.partie.team2Players.first.name;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Match Terminé !',
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.titleLarge?.copyWith(fontFamily: 'Oswald')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Text(
                        'VAINQUEUR',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'Oswald',
                          fontSize: 24,
                          letterSpacing: 2,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        winnerName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Score : ${matchState.manchesGagneesTeam1}/${matchState.manchesGagneesTeam2}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const MancheTable(),
                const Divider(height: 24),
                const Text(
                  "Après validation des scores, veuillez ramener la tablette à la table d'arbitrage.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Valider et Quitter'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchState matchState,
      MatchNotifier matchNotifier, bool isDouble) {
    final isGameStarted = matchState.scoreTeam1 > 0 ||
        matchState.scoreTeam2 > 0 ||
        matchState.manche > 1;

    Widget player1Widget = _buildPlayerButton(
        context, matchState, matchNotifier, isGameStarted, 1, isDouble);
    Widget player2Widget = _buildPlayerButton(
        context, matchState, matchNotifier, isGameStarted, 2, isDouble);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matchState.isSideSwapped
          ? [
              Expanded(child: player2Widget),
              if (!isGameStarted && !isDouble)
                _buildChangeSideButton(matchNotifier)
              else
                const SizedBox(width: 72),
              Expanded(child: player1Widget)
            ]
          : [
              Expanded(child: player1Widget),
              if (!isGameStarted && !isDouble)
                _buildChangeSideButton(matchNotifier)
              else
                const SizedBox(width: 72),
              Expanded(child: player2Widget)
            ],
    );
  }

  Widget _buildPlayerButton(
      BuildContext context,
      MatchState matchState,
      MatchNotifier matchNotifier,
      bool isGameStarted,
      int team,
      bool isDouble) {
    final String playerName;
    if (isDouble) {
      playerName = team == 1
          ? '${widget.partie.team1Players[0].name} & ${widget.partie.team1Players[1].name}'
          : '${widget.partie.team2Players[0].name} & ${widget.partie.team2Players[1].name}';
    } else {
      playerName = team == 1
          ? widget.partie.team1Players.first.name
          : widget.partie.team2Players.first.name;
    }
    final isServing = matchState.joueurAuService == playerName;
    final canServe = !isGameStarted;

    Color? backgroundColor;
    if (isServing) {
      backgroundColor = Colors.green.withAlpha(100);
    }

    return ElevatedButton.icon(
      onPressed:
          canServe && !isDouble ? () => matchNotifier.setServer(playerName) : null,
      icon: isServing
          ? const Icon(Icons.sports_cricket)
          : const Icon(Icons.sports_cricket, color: Colors.grey),
      label: Text(playerName),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
    );
  }

  Widget _buildChangeSideButton(MatchNotifier matchNotifier) {
    return ElevatedButton(
      onPressed: () => matchNotifier.swapSides(),
      child: const Icon(Icons.swap_horiz),
    );
  }

  Widget _buildPingPongTable(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(8.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(color: Colors.green[800]),
              Container(width: 4.0, color: Colors.white.withAlpha(77)),
              Container(height: 2.0, color: Colors.white.withAlpha(128)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoresRow(BuildContext context, MatchState matchState,
      MatchNotifier matchNotifier) {
    Widget score1Widget =
        _buildScoreControl(context, 1, matchState.scoreTeam1, matchNotifier);
    Widget score2Widget =
        _buildScoreControl(context, 2, matchState.scoreTeam2, matchNotifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: matchState.isSideSwapped
          ? [score2Widget, score1Widget]
          : [score1Widget, score2Widget],
    );
  }

  Widget _buildScoreControl(BuildContext context, int team, int score,
      MatchNotifier matchNotifier) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.red.shade800),
          onPressed: () => matchNotifier.decrementScore(team),
          style: IconButton.styleFrom(
              backgroundColor: Colors.red.shade100,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$score',
              style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 60,
                  color: team == 1
                      ? Colors.blue.withAlpha(178)
                      : Colors.red.withAlpha(178))),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.green.shade800),
          onPressed: () => matchNotifier.incrementScore(team),
          style: IconButton.styleFrom(
            backgroundColor: Colors.green.shade100,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsRow(
      BuildContext context, MatchState matchState, MatchNotifier matchNotifier) {
    Widget team1Actions =
        _buildTeamActions(context, matchState, matchNotifier, 1);
    Widget team2Actions =
        _buildTeamActions(context, matchState, matchNotifier, 2);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matchState.isSideSwapped
          ? [Expanded(child: team2Actions), Expanded(child: team1Actions)]
          : [Expanded(child: team1Actions), Expanded(child: team2Actions)],
    );
  }

  Widget _buildTeamActions(BuildContext context, MatchState matchState,
      MatchNotifier matchNotifier, int teamNumber) {
    final player = (teamNumber == 1)
        ? widget.partie.team1Players.first
        : widget.partie.team2Players.first;
    final isTimeoutUsed = (teamNumber == 1)
        ? matchState.tempsMortTeam1Utilise
        : matchState.tempsMortTeam2Utilise;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTimeoutButton(context, matchNotifier, teamNumber, isTimeoutUsed),
            const Divider(),
            _buildPlayerActions(context, matchNotifier, matchState, player),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutButton(BuildContext context, MatchNotifier matchNotifier,
      int teamNumber, bool isTimeoutUsed) {
    return InkWell(
      onTap: () => matchNotifier.utiliserTempsMort(teamNumber),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isTimeoutUsed
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            const SizedBox(width: 8),
            const Text('Temps Mort'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerActions(BuildContext context, MatchNotifier matchNotifier,
      MatchState matchState, Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(player.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildCardButtons(context, matchNotifier, matchState, player)
        ],
      ),
    );
  }

  Widget _buildCardButtons(BuildContext context, MatchNotifier matchNotifier,
      MatchState matchState, Player player) {
    final currentCard = matchNotifier.getCartonForPlayer(player.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCardButton(context, matchNotifier, player, Carton.jaune,
            Colors.yellow.shade700, currentCard),
        _buildCardButton(context, matchNotifier, player, Carton.jauneRouge,
            Colors.orange.shade700, currentCard),
        _buildCardButton(context, matchNotifier, player, Carton.rouge,
            Colors.red.shade800, currentCard),
      ],
    );
  }

  Widget _buildCardButton(
      BuildContext context,
      MatchNotifier matchNotifier,
      Player player,
      Carton carton,
      Color color,
      Carton? currentCard) {
    final bool isSelected = currentCard == carton;

    bool isTappable = true;
    if (isSelected) {
      isTappable = true;
    } else {
      switch (carton) {
        case Carton.jaune:
          isTappable = currentCard == null;
          break;
        case Carton.jauneRouge:
          isTappable = currentCard == Carton.jaune;
          break;
        case Carton.rouge:
          isTappable = currentCard == Carton.jauneRouge;
          break;
      }
    }

    return GestureDetector(
      onTap: isTappable
          ? () => matchNotifier.attribuerCarton(player.id, carton)
          : null,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? color
              : (isTappable ? color.withAlpha(64) : Colors.grey.withAlpha(80)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isTappable
                ? (isSelected ? Colors.black87 : Colors.black26)
                : Colors.transparent,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ]
              : [],
        ),
      ),
    );
  }
}
