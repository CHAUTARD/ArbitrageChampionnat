// features/table/double_table_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/match_selection/player_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/scoring/manche_table.dart';
import 'package:provider/provider.dart';

class DoubleTableScreen extends StatefulWidget {
  final Partie partie;

  const DoubleTableScreen({super.key, required this.partie});

  @override
  State<DoubleTableScreen> createState() => _DoubleTableScreenState();
}

class _DoubleTableScreenState extends State<DoubleTableScreen> {
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
          title: Text('Match Terminé !', textAlign: TextAlign.center, style: GoogleFonts.oswald(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Column(
                    children: [
                      Text(
                        'VAINQUEUR',
                        style: GoogleFonts.oswald(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        winnerTeamName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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

    final team1Names = widget.partie.team1Players.map((p) => p.name).join(' & ');
    final team2Names = widget.partie.team2Players.map((p) => p.name).join(' & ');
    final appBarSubtitle = '$team1Names vs $team2Names';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.partie.name, style: GoogleFonts.oswald(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
            Text(appBarSubtitle, style: GoogleFonts.roboto(fontSize: 14, color: Colors.white.withAlpha(204))),
          ],
        ),
        backgroundColor: theme.primaryColorDark,
        centerTitle: true,
        toolbarHeight: 65,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
                'Manche ${matchProvider.manche}',
                style: GoogleFonts.oswald(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildPlayersRow(context, matchProvider),
            const SizedBox(height: 16),
            _buildPingPongTable(context),
            const SizedBox(height: 16),
            _buildScoresRow(context, matchProvider),
            const SizedBox(height: 16),
            _buildActionsRow(context, matchProvider),
            const Spacer(),
            const MancheTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchProvider matchProvider) {
    Widget buildTeamWidget(List<Player> players) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: players.map((player) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildPlayerButton(context, player.name, matchProvider.joueurAuService == player.name, matchProvider.joueurReceveur == player.name),
          );
        }).toList(),
      );
    }

    Widget team1Widget = buildTeamWidget(widget.partie.team1Players);
    Widget team2Widget = buildTeamWidget(widget.partie.team2Players);
    final bool isGameStarted = matchProvider.scoreTeam1 > 0 || matchProvider.scoreTeam2 > 0 || matchProvider.manche > 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: matchProvider.isSideSwapped
          ? [Expanded(child: team2Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: team1Widget)]
          : [Expanded(child: team1Widget), if (!isGameStarted) _buildChangeSideButton(matchProvider) else const SizedBox(width: 72), Expanded(child: team2Widget)],
    );
  }

  Widget _buildPlayerButton(BuildContext context, String playerName, bool isServing, bool isReceiving) {
    Color? backgroundColor;
    if (isServing) {
      backgroundColor = Colors.green.withAlpha(100);
    } else if (isReceiving) {
      backgroundColor = Colors.purple.shade100;
    }
    return ElevatedButton.icon(
      onPressed: () => Provider.of<MatchProvider>(context, listen: false).setServer(playerName),
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
      flex: 2,
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
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.red.shade800),
          onPressed: () => matchProvider.decrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.red.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('$score', style: GoogleFonts.oswald(fontSize: 60, fontWeight: FontWeight.bold, color: team == 1 ? Colors.blue.withAlpha(178) : Colors.red.withAlpha(178))),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.green.shade800),
          onPressed: () => matchProvider.incrementScore(team),
          style: IconButton.styleFrom(backgroundColor: Colors.green.shade100, shape: const CircleBorder(), padding: const EdgeInsets.all(12)),
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
    final teamPlayers = (teamNumber == 1) ? widget.partie.team1Players : widget.partie.team2Players;
    final isTimeoutUsed = (teamNumber == 1) ? matchProvider.tempsMortTeam1Utilise : matchProvider.tempsMortTeam2Utilise;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: teamPlayers.map((player) => _buildPlayerActions(context, matchProvider, player, isTimeoutUsed)).toList(),
        ),
      ),
    );
  }

  Widget _buildPlayerActions(BuildContext context, MatchProvider matchProvider, Player player, bool isTimeoutUsed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 4), _buildCardButtons(context, matchProvider, player, isTimeoutUsed)],
      ),
    );
  }

  Widget _buildCardButtons(BuildContext context, MatchProvider matchProvider, Player player, bool isTimeoutUsed) {
    final currentCard = matchProvider.getCartonForPlayer(player.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCardButton(context, matchProvider, player, Carton.blanc, Colors.white, currentCard, isTimeoutUsed: isTimeoutUsed),
        _buildCardButton(context, matchProvider, player, Carton.jaune, Colors.yellow.shade700, currentCard),
        _buildCardButton(context, matchProvider, player, Carton.jauneRouge, Colors.orange.shade700, currentCard),
        _buildCardButton(context, matchProvider, player, Carton.rouge, Colors.red.shade800, currentCard),
      ],
    );
  }

  Widget _buildCardButton(BuildContext context, MatchProvider matchProvider, Player player, Carton carton, Color color, Carton? currentCard, {bool isTimeoutUsed = false}) {
    final bool isSelected = (carton == Carton.blanc) ? isTimeoutUsed : (currentCard == carton);

    bool isTappable = true;
    if (carton != Carton.blanc) {
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
          default: isTappable = false;
        }
      }
    } else {
      isTappable = !isTimeoutUsed;
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
        child: carton == Carton.blanc && isSelected ? const Icon(Icons.check, color: Colors.black, size: 20) : null,
      ),
    );
  }

}
