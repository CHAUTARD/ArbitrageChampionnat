import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/doubles_composition/configure_doubles_screen.dart';
import 'package:myapp/src/features/match_selection/partie_card.dart';
import 'package:myapp/src/features/scoring/table_screen.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match: ${match.equipeUn} vs ${match.equipeDeux}'),
        actions: [
          ValueListenableBuilder(
            valueListenable: Hive.box<Match>('matches').listenable(),
            builder: (context, matchesBox, child) {
              final currentMatch = matchesBox.get(match.id) ?? match;
              return IconButton(
                icon: const Icon(Icons.people_alt_outlined),
                tooltip: 'Modifier les doubles',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ConfigureDoublesScreen(match: currentMatch),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Player>>(
        valueListenable: Hive.box<Player>('players').listenable(),
        builder: (context, playersBox, _) {
          final players = playersBox.values.toList();

          return ValueListenableBuilder(
            valueListenable: Hive.box<Match>('matches').listenable(),
            builder: (context, matchesBox, child) {
              final currentMatch = matchesBox.get(match.id) ?? match;

              return ListView.builder(
                itemCount: currentMatch.parties.length,
                itemBuilder: (context, index) {
                  final partie = currentMatch.parties[index];
                  final team1Players = partie.team1PlayerIds
                      .map(
                        (id) => players.firstWhere(
                          (p) => p.id == id,
                          orElse: () => Player.unknown(),
                        ),
                      )
                      .toList();
                  final team2Players = partie.team2PlayerIds
                      .map(
                        (id) => players.firstWhere(
                          (p) => p.id == id,
                          orElse: () => Player.unknown(),
                        ),
                      )
                      .toList();
                  final arbitre = partie.arbitreId != null
                      ? players.firstWhere(
                          (p) => p.id == partie.arbitreId,
                          orElse: () => Player.unknown(),
                        )
                      : null;

                  return PartieCard(
                    partie: partie,
                    team1Players: team1Players,
                    team2Players: team2Players,
                    arbitre: arbitre,
                    onTap: () {
                      if (partie.isEditable) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ConfigureDoublesScreen(match: currentMatch),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TableScreen(partie: partie),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
