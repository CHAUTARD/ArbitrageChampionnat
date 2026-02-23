import 'package:flutter/material.dart';
import 'package:myapp/data/static_players_data.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/match_selection/partie_card.dart';

class MatchDetailsScreen extends StatelessWidget {
  final Match match;

  const MatchDetailsScreen({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final allPlayers = getStaticPlayers();

    Player? getPlayerById(String id) {
      try {
        return allPlayers.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    }

    List<Player> getPlayersByIds(List<String> ids) {
      return ids.map((id) => getPlayerById(id)).whereType<Player>().toList();
    }

    final scoreUn = match.parties.fold<int>(
        0, (previousValue, element) => previousValue + (element.scoreEquipeUn ?? 0));
    final scoreDeux = match.parties.fold<int>(
        0, (previousValue, element) => previousValue + (element.scoreEquipeDeux ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: Text('${match.equipeUn} vs ${match.equipeDeux}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Score final: $scoreUn - $scoreDeux',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: match.parties.length,
        itemBuilder: (context, index) {
          final partie = match.parties[index];
          final team1Players = getPlayersByIds(partie.team1PlayerIds);
          final team2Players = getPlayersByIds(partie.team2PlayerIds);
          final arbitre = partie.arbitreId != null ? getPlayerById(partie.arbitreId!) : null;

          return PartieCard(
            partie: partie,
            team1Players: team1Players,
            team2Players: team2Players,
            arbitre: arbitre,
            onTap: () {
              // Possibilité de naviguer vers un écran d'édition de la partie
            },
          );
        },
      ),
    );
  }
}
