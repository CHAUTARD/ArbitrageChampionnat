import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:myapp/src/widgets/timer_dialog.dart';
import 'package:provider/provider.dart';

class DoubleTableScreen extends StatefulWidget {
  final Partie partie;

  const DoubleTableScreen({super.key, required this.partie});

  @override
  State<DoubleTableScreen> createState() => _DoubleTableScreenState();
}

class _DoubleTableScreenState extends State<DoubleTableScreen> {
  bool _isDialogShown = false;
  bool _showCartons = false;
  int _currentManche = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);

    if (matchProvider.manche > _currentManche && matchProvider.manche > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTimerDialog(context, duration: const Duration(minutes: 1), title: 'Changement de côté');
        }
      });
      setState(() {
        _currentManche = matchProvider.manche;
      });
    }

    if (!matchProvider.isServiceSelectionDone && matchProvider.manche == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showFirstMancheServiceSelectionDialogs(matchProvider);
        }
      });
    }

    if (matchProvider.isMatchFinished && !_isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showEndGameDialog(matchProvider);
          setState(() {
            _isDialogShown = true;
          });
        }
      });
    }
  }

  Future<void> _showFirstMancheServiceSelectionDialogs(MatchProvider matchProvider) async {
    final server = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Qui commence au service ?'),
          children: widget.partie.team1Players
              .expand((p) => [
                    SimpleDialogOption(
                      onPressed: () => Navigator.pop(context, p.name),
                      child: Text(p.name),
                    ),
                  ])
              .toList()
            ..addAll(widget.partie.team2Players
                .expand((p) => [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, p.name),
                        child: Text(p.name),
                      ),
                    ])
                .toList()),
        );
      },
    );

    if (!mounted || server == null) return;

    matchProvider.setServer(server);

    final serverIsInTeam1 = widget.partie.team1Players.any((p) => p.name == server);
    final opponents = serverIsInTeam1 ? widget.partie.team2Players : widget.partie.team1Players;

    final receiver = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Qui est le receveur ?'),
          children: opponents
              .map((p) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, p.name),
                    child: Text(p.name),
                  ))
              .toList(),
        );
      },
    );

    if (!mounted || receiver == null) return;

    matchProvider.setReceiver(receiver);
    matchProvider.completeServiceSelection();

    showTimerDialog(context, duration: const Duration(minutes: 2), title: 'Début de partie');
  }

  void _showEndGameDialog(MatchProvider matchProvider) {
    final winnerTeamNumber = matchProvider.winnerTeam;
    final theme = Theme.of(context);
    final winnerTeamName = winnerTeamNumber == 1
        ? widget.partie.team1Players.map((p) => p.name).join(' & ')
        : widget.partie.team2Players.map((p) => p.name).join(' & ');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Match Terminé !', textAlign: TextAlign.center, style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Oswald')),
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
                        winnerTeamName,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Score : ${matchProvider.manchesGagneesTeam1}/${matchProvider.manchesGagneesTeam2}',
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
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Valider et Quitter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final theme = Theme.of(context);

    final team1Names = widget.partie.team1Players.map((p) => p.name).join(' & ');
    final team2Names = widget.partie.team2Players.map((p) => p.name).join(' & ');
    final appBarSubtitle = '$team1Names vs $team2Names';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Partie #${widget.partie.id}', style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 20)),
            Text(appBarSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withAlpha(204))),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 65,
        actions: [
          if (matchProvider.isServiceSelectionDone)
            IconButton(
              tooltip: 'Afficher/Masquer les cartons',
              onPressed: () {
                setState(() {
                  _showCartons = !_showCartons;
                });
              },
              icon: Icon(_showCartons ? Icons.style : Icons.style_outlined),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: matchProvider.isServiceSelectionDone
            ? _buildMatchView(context, matchProvider)
            : (matchProvider.manche > 1
                ? _buildServiceSelectionView(context, matchProvider)
                : const Center(child: CircularProgressIndicator())),
      ),
    );
  }

  Widget _buildMatchView(BuildContext context, MatchProvider matchProvider) {
    return Column(
      children: [
        Text('Manche ${matchProvider.manche}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Oswald', fontSize: 20)),
        const SizedBox(height: 16),
        _buildPlayersRow(context, matchProvider),
        const SizedBox(height: 16),
        _buildPingPongTable(context),
        const SizedBox(height: 16),
        _buildScoresRow(context, matchProvider),
        const SizedBox(height: 16),
        if (_showCartons) _buildActionsRow(context, matchProvider),
        const MancheTable(),
      ],
    );
  }

  Widget _buildServiceSelectionView(BuildContext context, MatchProvider matchProvider) {
    final team1 = widget.partie.team1Players;
    final team2 = widget.partie.team2Players;

    final server = matchProvider.joueurAuService;
    final receiver = matchProvider.joueurReceveur;

    final bool canStart = server != null && receiver != null;

    final lastMancheWinner =
        matchProvider.games.isNotEmpty ? (matchProvider.games.last.score1 > matchProvider.games.last.score2 ? 1 : 2) : 1;
    final isTeam1Starting = matchProvider.manche % 2 == 1;
    final servingTeamNumber = isTeam1Starting ? lastMancheWinner : (lastMancheWinner == 1 ? 2 : 1);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Qui commence au service ?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontFamily: 'Oswald'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTeamSelection(context, matchProvider, team1, 1, servingTeamNumber),
            _buildTeamSelection(context, matchProvider, team2, 2, servingTeamNumber),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: canStart ? () => matchProvider.completeServiceSelection() : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Commencer la manche'),
        ),
      ],
    );
  }

  Widget _buildTeamSelection(
      BuildContext context, MatchProvider matchProvider, List<Player> players, int teamNumber, int servingTeam) {
    bool canSelectServer = matchProvider.joueurAuService == null && teamNumber == servingTeam;

    return Column(
      children: players.map((player) {
        final isServer = matchProvider.joueurAuService == player.name;
        final isReceiver = matchProvider.joueurReceveur == player.name;
        bool isClickable = canSelectServer;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: isClickable
                ? () {
                    if (canSelectServer) {
                      matchProvider.setServer(player.name);
                      matchProvider.completeServiceSelection();
                    }
                  }
                : null,
            child: Opacity(
              opacity: isClickable || isServer || isReceiver ? 1.0 : 0.5,
              child: Card(
                color: isServer ? Colors.green.withAlpha(100) : (isReceiver ? Colors.purple.shade100 : null),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: [
                      Text(player.name, style: Theme.of(context).textTheme.titleLarge),
                      if (isServer) const Text('Serveur', style: TextStyle(color: Colors.green)),
                      if (isReceiver) const Text('Receveur', style: TextStyle(color: Colors.purple)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchProvider matchProvider) {
    final isGameStarted = matchProvider.scoreTeam1 > 0 || matchProvider.scoreTeam2 > 0 || matchProvider.manche > 1;

    Widget buildTeamWidget(List<Player> players, MatchProvider matchProvider, bool isGameStarted) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: players.map((player) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildPlayerButton(context, player, matchProvider, isGameStarted),
          );
        }).toList(),
      );
    }

    Widget team1Widget = buildTeamWidget(widget.partie.team1Players, matchProvider, isGameStarted);
    Widget team2Widget = buildTeamWidget(widget.partie.team2Players, matchProvider, isGameStarted);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: matchProvider.isSideSwapped
          ? [
              Expanded(child: team2Widget),
              if (!isGameStarted) _buildChangeSideButton(context, matchProvider) else const SizedBox(width: 72),
              Expanded(child: team1Widget)
            ]
          : [
              Expanded(child: team1Widget),
              if (!isGameStarted) _buildChangeSideButton(context, matchProvider) else const SizedBox(width: 72),
              Expanded(child: team2Widget)
            ],
    );
  }

  Widget _buildPlayerButton(BuildContext context, Player player, MatchProvider matchProvider, bool isGameStarted) {
    final isServing = matchProvider.joueurAuService == player.name;
    final isReceiving = matchProvider.joueurReceveur == player.name;

    Color? backgroundColor;
    if (isServing) {
      backgroundColor = Colors.green.withAlpha(100);
    } else if (isReceiving) {
      backgroundColor = Colors.purple.shade100;
    }

    return ElevatedButton.icon(
      onPressed: isGameStarted ? null : () {},
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isServing) const Icon(Icons.sports_cricket),
          if (isReceiving) const Icon(Icons.ads_click),
        ],
      ),
      label: Text(player.name),
    );
  }

  Widget _buildChangeSideButton(BuildContext context, MatchProvider matchProvider) {
    return ElevatedButton(
      onPressed: () {
        matchProvider.changerDeCote();
        showTimerDialog(context, duration: const Duration(minutes: 1), title: 'Changement de côté');
      },
      child: const Icon(Icons.swap_horiz),
    );
  }

  Widget _buildPingPongTable(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2.0), borderRadius: BorderRadius.circular(8.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(color: Colors.green[800]),
              Container(width: 4.0, color: Colors.white.withAlpha(77)),
              Container(height: 2.0, color: Colors.white.withAlpha(128))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoresRow(BuildContext context, MatchProvider matchProvider) {
    Widget score1Widget = _buildScoreControl(context, 1, matchProvider.scoreTeam1, matchProvider);
    Widget score2Widget = _buildScoreControl(context, 2, matchProvider.scoreTeam2, matchProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: matchProvider.isSideSwapped ? [score2Widget, score1Widget] : [score1Widget, score2Widget],
    );
  }

  Widget _buildScoreControl(BuildContext context, int team, int score, MatchProvider matchProvider) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => matchProvider.decrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.red.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
          icon: Icon(Icons.remove, color: Colors.red.shade800),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$score', style: theme.textTheme.displayLarge?.copyWith(fontSize: 60, color: team == 1 ? Colors.blue.withAlpha(178) : Colors.red.withAlpha(178))),
        ),
        IconButton(
          onPressed: () => matchProvider.incrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.green.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
          icon: Icon(Icons.add, color: Colors.green.shade800),
        ),
      ],
    );
  }

  Widget _buildActionsRow(BuildContext context, MatchProvider matchProvider) {
    Widget team1Actions = _buildTeamActions(context, matchProvider, 1);
    Widget team2Actions = _buildTeamActions(context, matchProvider, 2);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matchProvider.isSideSwapped
          ? [Expanded(child: team2Actions), Expanded(child: team1Actions)]
          : [Expanded(child: team1Actions), Expanded(child: team2Actions)],
    );
  }

  Widget _buildTeamActions(BuildContext context, MatchProvider matchProvider, int teamNumber) {
    final teamPlayers = (teamNumber == 1) ? widget.partie.team1Players : widget.partie.team2Players;
    final isTimeoutUsed = (teamNumber == 1) ? matchProvider.tempsMortTeam1Utilise : matchProvider.tempsMortTeam2Utilise;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTimeoutButton(context, matchProvider, teamNumber, isTimeoutUsed),
            const Divider(),
            ...teamPlayers.map((player) => _buildPlayerActions(context, matchProvider, player)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutButton(BuildContext context, MatchProvider matchProvider, int teamNumber, bool isTimeoutUsed) {
    return InkWell(
      onTap: () {
        if (!isTimeoutUsed) {
          matchProvider.utiliserTempsMort(teamNumber);
          showTimerDialog(context, duration: const Duration(minutes: 1), title: 'Temps Mort');
        } else {
          matchProvider.utiliserTempsMort(teamNumber); // To un-check it if needed
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isTimeoutUsed ? Icons.check_box : Icons.check_box_outline_blank),
            const SizedBox(width: 8),
            const Text('Temps Mort'),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerActions(BuildContext context, MatchProvider matchProvider, Player player) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          _buildCardButtons(context, matchProvider, player)
        ],
      ),
    );
  }

  Widget _buildCardButtons(BuildContext context, MatchProvider matchProvider, Player player) {
    final currentCard = matchProvider.getCartonForPlayer(player.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCardButton(context, matchProvider, player, Carton.jaune, Colors.yellow.shade700, currentCard),
        _buildCardButton(context, matchProvider, player, Carton.jauneRouge, Colors.orange.shade700, currentCard),
        _buildCardButton(context, matchProvider, player, Carton.rouge, Colors.red.shade800, currentCard),
      ],
    );
  }

  Widget _buildCardButton(
      BuildContext context, MatchProvider matchProvider, Player player, Carton carton, Color color, Carton? currentCard) {
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
      onTap: isTappable ? () => matchProvider.attribuerCarton(player.id, carton) : null,
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 30,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color : (isTappable ? color.withAlpha(64) : Colors.grey.withAlpha(80)),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isTappable ? (isSelected ? Colors.black87 : Colors.black26) : Colors.transparent,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))] : [],
        ),
      ),
    );
  }
}
