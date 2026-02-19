// features/table/table_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
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
   bool _showCartons = false; 

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
    final winnerName = winnerTeamNumber == 1
        ? widget.partie.team1Players.first.name
        : widget.partie.team2Players.first.name;

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
                        winnerName,
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




  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final player1 = widget.partie.team1Players.first;
    final player2 = widget.partie.team2Players.first;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Partie #${widget.partie.id}', style: theme.appBarTheme.titleTextStyle?.copyWith(fontSize: 20)),
            Text('${player1.name} vs ${player2.name}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withAlpha(204)))
          ],
        ),
        centerTitle: true,
        toolbarHeight: 65,
         actions: [
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
            Text(
                'Manche ${matchProvider.manche}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Oswald', fontSize: 20)),
            const SizedBox(height: 16),
            _buildPlayersRow(context, matchProvider, player1, player2),
            const SizedBox(height: 16),
            _buildPingPongTable(context),
            const SizedBox(height: 16),
            _buildScoresRow(context, matchProvider),
            const SizedBox(height: 16),
             if (_showCartons)
              _buildActionsRow(context, matchProvider),
            const MancheTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchProvider matchProvider, Player player1, Player player2) {
    final isGameStarted = matchProvider.scoreTeam1 > 0 || matchProvider.scoreTeam2 > 0 || matchProvider.manche > 1;
    
    Widget player1Widget = _buildPlayerButton(context, player1, matchProvider, isGameStarted, 1);
    Widget player2Widget = _buildPlayerButton(context, player2, matchProvider, isGameStarted, 2);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matchProvider.isSideSwapped
          ? [Expanded(child: player2Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: player1Widget)]
          : [Expanded(child: player1Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: player2Widget)],
    );
  }

 Widget _buildPlayerButton(BuildContext context, Player player, MatchProvider matchProvider, bool isGameStarted, int team) {
  final isServing = matchProvider.joueurAuService == player.name;
  final canServe = !isGameStarted;
  
  Color? backgroundColor;
  if (isServing) {
    backgroundColor = Colors.green.withAlpha(100);
  }

  return ElevatedButton.icon(
    onPressed: canServe ? () => matchProvider.setServer(player.name) : null,
    icon: isServing ? const Icon(Icons.sports_cricket) : const Icon(Icons.sports_cricket, color: Colors.grey),
    label: Text(player.name),
    style: ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
    ),
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

  Widget _buildScoresRow(BuildContext context, MatchProvider matchProvider) {
    Widget score1Widget = _buildScoreControl(context, 1, matchProvider.scoreTeam1, matchProvider);
    Widget score2Widget = _buildScoreControl(context, 2, matchProvider.scoreTeam2, matchProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: matchProvider.isSideSwapped
          ? [score2Widget, score1Widget]
          : [score1Widget, score2Widget],
    );
  }

  Widget _buildScoreControl(
      BuildContext context, int team, int score, MatchProvider matchProvider) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.red.shade800),
          onPressed: () => matchProvider.decrementScore(team),
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
          onPressed: () => matchProvider.incrementScore(team),
          style: IconButton.styleFrom(
            backgroundColor: Colors.green.shade100,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }




Widget _buildActionsRow(BuildContext context, MatchProvider matchProvider) {
    Widget team1Actions = _buildTeamActions(context, matchProvider, 1);
    Widget team2Actions = _buildTeamActions(context, matchProvider, 2);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: matchProvider.isSideSwapped ? [Expanded(child: team2Actions), Expanded(child: team1Actions)] : [Expanded(child: team1Actions), Expanded(child: team2Actions)],
    );
  }

  Widget _buildTeamActions(BuildContext context, MatchProvider matchProvider, int teamNumber) {
    final player = (teamNumber == 1) ? widget.partie.team1Players.first : widget.partie.team2Players.first;
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
           _buildPlayerActions(context, matchProvider, player),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeoutButton(BuildContext context, MatchProvider matchProvider, int teamNumber, bool isTimeoutUsed) {
    return InkWell(
      onTap: () => matchProvider.utiliserTempsMort(teamNumber),
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
        children: [Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), _buildCardButtons(context, matchProvider, player)],
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

  Widget _buildCardButton(BuildContext context, MatchProvider matchProvider, Player player, Carton carton, Color color, Carton? currentCard) {
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
