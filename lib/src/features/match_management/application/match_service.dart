import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/main.dart'; // Import main.dart to get isarServiceProvider
import 'package:myapp/models/match.dart';
import 'package:myapp/src/features/core/data/isar_service.dart';
import 'package:isar/isar.dart';

// Provider for the MatchService
final matchServiceProvider = Provider((ref) {
  final isarService = ref.watch(isarServiceProvider);
  return MatchService(isarService);
});

class MatchService {
  final IsarService _isarService;

  MatchService(this._isarService);

  Stream<List<Match>> getMatches() async* {
    final isar = await _isarService.db;
    yield* isar.matchs.where().watch(fireImmediately: true);
  }

  Future<void> addMatch(Match match) async {
    final isar = await _isarService.db;
    isar.writeTxnSync(() => isar.matchs.putSync(match));
  }

  Future<void> updateMatch(Match match) async {
    final isar = await _isarService.db;
    isar.writeTxnSync(() => isar.matchs.putSync(match));
  }

  Future<void> deleteMatch(String matchId) async {
    final isar = await _isarService.db;
    final match = await isar.matchs
        .where()
        .filter()
        .idEqualTo(matchId)
        .findFirst();
    if (match != null && match.id != null) {
      isar.writeTxnSync(() => isar.matchs.deleteSync(int.parse(match.id!)));
    }
  }
}
