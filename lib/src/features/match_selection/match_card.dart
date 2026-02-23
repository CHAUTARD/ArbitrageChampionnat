import 'package:flutter/material.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/match_details/presentation/match_details_screen.dart';

class MatchCard extends StatelessWidget {
  final Match match;

  const MatchCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final scoreUn = match.parties.fold<int>(
      0,
      (previousValue, element) => previousValue + (element.scoreEquipeUn ?? 0),
    );
    final scoreDeux = match.parties.fold<int>(
      0,
      (previousValue, element) =>
          previousValue + (element.scoreEquipeDeux ?? 0),
    );

    return Card(
      child: ListTile(
        title: Text('${match.equipeUn} vs ${match.equipeDeux}'),
        subtitle: Text('Score: $scoreUn - $scoreDeux'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MatchDetailsScreen(match: match),
            ),
          );
        },
      ),
    );
  }
}
