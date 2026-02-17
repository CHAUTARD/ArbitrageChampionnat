import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/match_selection/partie_model.dart';
import 'package:myapp/src/features/table/double_table_screen.dart';
import 'package:myapp/src/features/table/table_screen.dart';
import 'package:provider/provider.dart';

import 'package:myapp/src/features/scoring/match_provider.dart';

class PartieCard extends StatelessWidget {
  final Partie partie;

  const PartieCard({super.key, required this.partie});

  void _navigateToTableScreen(BuildContext context) {
    final matchProvider = Provider.of<MatchProvider>(context, listen: false);
    matchProvider.startMatch(partie);

    final isDouble = partie.team1Players.length > 1;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isDouble ? DoubleTableScreen(partie: partie) : TableScreen(partie: partie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final team1Name = partie.team1Players.map((p) => p.name).join(' & ');
    final team2Name = partie.team2Players.map((p) => p.name).join(' & ');
    final formattedTime = DateFormat('HH:mm').format(partie.horaire);

    return Card(
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
                partie.name,
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
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        formattedTime,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Table ${partie.table}',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
