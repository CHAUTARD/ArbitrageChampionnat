// partie_list_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myapp/models/match.dart';
import 'package:myapp/models/partie_model.dart';
import 'package:myapp/models/player_model.dart';
import 'package:myapp/src/features/doubles_composition/configure_doubles_screen.dart';
import 'package:myapp/src/features/match_management/presentation/match_list_screen.dart';
import 'package:myapp/src/features/match_selection/partie_card.dart';
import 'package:myapp/src/features/scoring/table_screen.dart';

class PartieListScreen extends StatefulWidget {
  final Match match;

  const PartieListScreen({super.key, required this.match});

  @override
  State<PartieListScreen> createState() => _PartieListScreenState();
}

class _PartieListScreenState extends State<PartieListScreen> {
  late Future<List<Player>> _playersFuture;

  @override
  void initState() {
    super.initState();
    _playersFuture = _loadPlayers();
  }

  Future<List<Player>> _loadPlayers() async {
    final box = await Hive.openBox<Player>('players');
    // Ensure players for the current match are loaded
    return box.values.where((p) => p.id.startsWith(widget.match.id)).toList();
  }

  Player _findPlayerById(List<Player> players, String id) {
    return players.firstWhere(
      (player) => player.id == id,
      orElse: () => Player(id: '', name: 'Non assigné', equipe: '', lettre: ''),
    );
  }

  void _navigateToTable(Partie partie) {
    // Check if the players for the match are defined
    if (partie.team1PlayerIds.isEmpty || partie.team2PlayerIds.isEmpty) {
      if (partie.isEditable) {
        // For editable doubles, guide the user to the configuration screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Veuillez d\'abord configurer les équipes de double.',
            ),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfigureDoublesScreen(match: widget.match),
          ),
        ).then(
          (_) => setState(() {
            _playersFuture = _loadPlayers();
          }),
        ); // Refresh on return
      } else {
        // For fixed matches with missing players (should not happen in normal flow)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Les joueurs pour cette partie ne sont pas définis.'),
          ),
        );
      }
    } else {
      // Proceed to scoring screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TableScreen(partie: partie)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fiche de partie'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MatchListScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          // The icon to edit doubles is removed as per the new workflow.
          // The user is now automatically redirected to the configuration screen.
        ],
      ),
      body: FutureBuilder<List<Player>>(
        future: _playersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun joueur trouvé pour ce match.'),
            );
          }

          final players = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: widget.match.parties.length,
            itemBuilder: (context, index) {
              final partie = widget.match.parties[index];
              final team1Players = partie.team1PlayerIds
                  .map((id) => _findPlayerById(players, id))
                  .toList();
              final team2Players = partie.team2PlayerIds
                  .map((id) => _findPlayerById(players, id))
                  .toList();
              final arbitre = partie.arbitreId != null
                  ? _findPlayerById(players, partie.arbitreId!)
                  : null;

              return PartieCard(
                partie: partie,
                team1Players: team1Players,
                team2Players: team2Players,
                arbitre: arbitre,
                onTap: () => _navigateToTable(partie),
              );
            },
          );
        },
      ),
    );
  }
}
