// features/table/table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/manche_indicator.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatefulWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  bool _isDialogShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final matchProvider = Provider.of<MatchProvider>(context);

    if (matchProvider.isMatchFinished && !_isDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showEndGameDialog(context, matchProvider);
        setState(() {
          _isDialogShown = true;
        });
      });
    }
  }

  void _showEndGameDialog(BuildContext context, MatchProvider matchProvider) {
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
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

    String appBarSubtitle;
    if (widget.partie.team1Players.length > 1) {
      final team1Names = widget.partie.team1Players.map((p) => p.name).join(' & ');
      final team2Names = widget.partie.team2Players.map((p) => p.name).join(' & ');
      appBarSubtitle = '$team1Names vs $team2Names';
    } else {
      if (widget.partie.arbitre != null) {
        appBarSubtitle = 'Arbitrage : ${widget.partie.arbitre!.name}';
      } else {
        appBarSubtitle = 'Arbitrage';
      }
    }

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                'Manche ${matchProvider.manche}',
                style: theme.textTheme.titleLarge?.copyWith(fontFamily: 'Oswald', fontSize: 20)),
            const SizedBox(height: 16),
            _buildPlayersRow(context, matchProvider),
            const SizedBox(height: 16),
            _buildPingPongTable(context),
            const SizedBox(height: 16),
            _buildScoresRow(context, matchProvider),
             const SizedBox(height: 16),
            MancheIndicator(
                manchesGagneesTeam1: matchProvider.manchesGagneesTeam1,
                manchesGagneesTeam2: matchProvider.manchesGagneesTeam2,
                isSideSwapped: matchProvider.isSideSwapped,
            ),
            const MancheTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchProvider matchProvider) {
    final isDouble = widget.partie.team1Players.length > 1;
    final bool isGameStarted = matchProvider.scoreTeam1 > 0 || matchProvider.scoreTeam2 > 0 || matchProvider.manche > 1;

    Widget buildTeamWidget(List<dynamic> players) {
      if (players.isEmpty) return Container();
      if (!isDouble) {
        final player = players.first;
        return _buildPlayerButton(context, player.name, matchProvider.joueurAuService == player.name, matchProvider.joueurReceveur == player.name, isGameStarted);
      } else {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: players.map((player) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: _buildPlayerButton(context, player.name, matchProvider.joueurAuService == player.name, matchProvider.joueurReceveur == player.name, isGameStarted),
            );
          }).toList(),
        );
      }
    }

    Widget team1Widget = buildTeamWidget(widget.partie.team1Players);
    Widget team2Widget = buildTeamWidget(widget.partie.team2Players);


    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: matchProvider.isSideSwapped
          ? [Expanded(child: team2Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: team1Widget)]
          : [Expanded(child: team1Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: team2Widget)],
    );
  }

  Widget _buildPlayerButton(BuildContext context, String playerName, bool isServing, bool isReceiving, bool isGameStarted) {
    Color? backgroundColor;
    if (isServing) {
      backgroundColor = Colors.green.withAlpha(100);
    } else if (isReceiving) {
      backgroundColor = Colors.purple.shade100;
    }
    return ElevatedButton.icon(
      onPressed: isGameStarted ? null : () => Provider.of<MatchProvider>(context, listen: false).setServer(playerName),
      icon: isServing ? const Icon(Icons.sports_cricket) : const SizedBox.shrink(),
      label: Text(playerName),
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
    );
  }

  Widget _buildChangeSideButton(MatchProvider matchProvider) {
    return ElevatedButton(
      onPressed: () => matchProvider.changerDeCote(),
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
            children: [Container(color: Colors.green[800]), Container(width: 4.0, color: Colors.white.withAlpha(77)), Container(height: 2.0, color: Colors.white.withAlpha(128))],
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
          icon: Icon(Icons.remove, color: Colors.red.shade800),
          onPressed: () => matchProvider.decrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.red.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$score', style: theme.textTheme.displayLarge?.copyWith(fontSize: 60, color: team == 1 ? Colors.blue.withAlpha(178) : Colors.red.withAlpha(178))),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.green.shade800),
          onPressed: () => matchProvider.incrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.green.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
        ),
      ],
    );
  }
}
