import 'package:hive/hive.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:uuid/uuid.dart';

class TeamService {
  final Box<Equipe> _equipesBox;
  final _uuid = const Uuid();

  TeamService(this._equipesBox);

  Future<void> addTeam(Equipe equipe) async {
    final newTeam = Equipe(
      id: _uuid.v4(),
      nom: equipe.nom,
      joueurs: equipe.joueurs,
    );
    await _equipesBox.put(newTeam.id, newTeam);
  }

  Future<void> updateTeam(Equipe equipe) async {
    await _equipesBox.put(equipe.id, equipe);
  }

  Future<void> deleteTeam(String teamId) async {
    await _equipesBox.delete(teamId);
  }

  Stream<List<Equipe>> getTeams() {
    return _equipesBox.watch().map((_) => _equipesBox.values.toList());
  }
}
