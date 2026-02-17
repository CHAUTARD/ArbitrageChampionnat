import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/scoring/match_provider.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/table_screen.dart';
import 'package:provider/provider.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;

  const PartieCard({super.key, required this.partie});

  void _navigateToTableScreen(BuildContext context) {
    if (partie.isPlayed) {
      _showScoreDialog(context);
    } else {
      final matchProvider = Provider.of<MatchProvider>(context, listen: false);
      matchProvider.startMatch(partie);

      final isDouble = partie.team1Players.length > 1;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isDouble
              ? DoubleTableScreen(partie: partie)
              : TableScreen(partie: partie),
        ),
      );
    }
  }

  void _showScoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Score de la partie #${partie.id}'),
        content: Text('Le score est : ${partie.score}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final team1Name = partie.team1Players.map((p) => p.name).join(' & ');
    final team2Name = partie.team2Players.map((p) => p.name).join(' & ');
    final cardColor =
        partie.isPlayed ? Colors.grey.shade300 : Colors.green.shade100;

    return Card(
      color: cardColor,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: () => _navigateToTableScreen(context),
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Partie #${partie.id}',
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$team1Name vs $team2Name',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              if (partie.arbitre != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Arbitre : ${partie.arbitre!.name}',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              if (partie.isPlayed)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Score : ${partie.score}',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
