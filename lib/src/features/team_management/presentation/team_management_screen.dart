import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:myapp/src/features/team_management/application/team_service.dart';
import 'package:myapp/src/features/team_management/presentation/add_team_screen.dart';
import 'package:myapp/src/features/team_management/presentation/edit_team_screen.dart';

class TeamManagementScreen extends StatelessWidget {
  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamService = Provider.of<TeamService>(context);
    final teamsStream = teamService.getTeams();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des équipes'),
      ),
      body: StreamBuilder<List<Equipe>>(
        stream: teamsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune équipe trouvée.'));
          }

          final teams = snapshot.data!;
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return ListTile(
                title: Text(team.nom),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditTeamScreen(team: team),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        teamService.deleteTeam(team.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddTeamScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
