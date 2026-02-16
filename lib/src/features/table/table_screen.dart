// features/table/table_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:provider/provider.dart';

class TableScreen extends StatelessWidget {
  final Partie partie;

  const TableScreen({super.key, required this.partie});

  @override
  Widget build(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context);
    final theme = Theme.of(context);

    final team1PlayerName = partie.team1Players.isNotEmpty ? partie.team1Players[0].name : 'Equipe 1';
    final team2PlayerName = partie.team2Players.isNotEmpty ? partie.team2Players[0].name : 'Equipe 2';
    final vsTitle = '$team1PlayerName vs $team2PlayerName';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              partie.name,
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Text(
              vsTitle,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.white.withAlpha(204), // Corrected from withOpacity
              ),
            ),
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
              style: GoogleFonts.oswald(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPlayersRow(context, matchProvider),
            const SizedBox(height: 16),
            _buildPingPongTable(context),
            const SizedBox(height: 16),
            _buildScoresRow(context, matchProvider),
            const SizedBox(height: 16),
            _buildManchesResult(context, matchProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersRow(BuildContext context, MatchProvider matchProvider) {
    final team1PlayerName = partie.team1Players.isNotEmpty ? partie.team1Players[0].name : 'Equipe 1';
    final team2PlayerName = partie.team2Players.isNotEmpty ? partie.team2Players[0].name : 'Equipe 2';

    final player1IsServing = matchProvider.joueurAuService == team1PlayerName;
    final player2IsServing = matchProvider.joueurAuService == team2PlayerName;

    Widget player1Widget = _buildPlayerButton(team1PlayerName, player1IsServing);
    Widget player2Widget = _buildPlayerButton(team2PlayerName, player2IsServing);


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: matchProvider.isSideSwapped
          ? [player2Widget, _buildChangeSideButton(matchProvider), player1Widget]
          : [player1Widget, _buildChangeSideButton(matchProvider), player2Widget],
    );
  }

  Widget _buildPlayerButton(String playerName, bool isServing) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: isServing ? Icon(Icons.sports_tennis) : SizedBox.shrink(),
      label: Text(playerName),
      style: ElevatedButton.styleFrom(
        backgroundColor: isServing ? Colors.green.withAlpha(100) : null, // Only color if serving
      ),
    );
  }

  Widget _buildChangeSideButton(MatchProvider matchProvider) {
    return ElevatedButton(
      onPressed: () => matchProvider.changerDeCote(),
      child: Icon(Icons.swap_horiz),
    );
  }

  Widget _buildPingPongTable(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0), // Must be slightly less than the container's radius
          child: Stack(
            alignment: Alignment.center,
            children: [
              // The table surface color
              Container(
                color: Colors.green[800],
              ),
              // The vertical center line
              Container(
                width: 2.0,
                color: Colors.white.withAlpha(128),
              ),
              // The net
              Container(
                height: 4.0,
                color: Colors.white.withAlpha(77),
              ),
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

  Widget _buildScoreControl(BuildContext context, int team, int score, MatchProvider matchProvider) {
    final color = team == 1 ? Colors.blue : Colors.red;
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove, color: Colors.white),
          onPressed: () => matchProvider.decrementScore(team),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.shade600,
            shape: CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '$score',
            style: GoogleFonts.oswald(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: color.withAlpha(178),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () => matchProvider.incrementScore(team),
          style: IconButton.styleFrom(
            backgroundColor: color,
            shape: CircleBorder(),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildManchesResult(BuildContext context, MatchProvider matchProvider) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Text('Résultats des Manches', style: GoogleFonts.oswald(fontSize: 18, fontWeight: FontWeight.bold)),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Manche')),
              DataColumn(label: Text('Score')),
            ],
            rows: List<DataRow>.generate(
              matchProvider.scoresManches.length,
              (index) => DataRow(
                cells: <DataCell>[
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(matchProvider.scoresManches[index])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
