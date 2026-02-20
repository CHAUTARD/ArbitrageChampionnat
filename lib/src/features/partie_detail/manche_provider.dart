import 'package:flutter/material.dart';
import 'package:myapp/src/features/partie_detail/manche_model.dart';

class MancheProvider extends ChangeNotifier {
  List<Manche> _manches = [];
  bool _isLoading = false;

  List<Manche> get manches => _manches;
  bool get isLoading => _isLoading;

  Future<void> loadManches(int partieId) async {
    _isLoading = true;
    notifyListeners();
    // This is where you would typically fetch data from a database or API
    _manches = []; // Replace with actual data fetching logic
    _isLoading = false;
    notifyListeners();
  }

  void addManche(int partieId, int numeroManche, int scoreTeam1, int scoreTeam2) {
    final newManche = Manche(
      id: DateTime.now().millisecondsSinceEpoch, // Or a proper unique ID
      partieId: partieId,
      numeroManche: numeroManche,
      scoreTeam1: scoreTeam1,
      scoreTeam2: scoreTeam2,
    );
    _manches.add(newManche);
    notifyListeners();
  }

  void updateManche(Manche a) {
    final index = _manches.indexWhere((m) => m.id == a.id);
    if (index != -1) {
      _manches[index] = a;
      notifyListeners();
    }
  }
}
