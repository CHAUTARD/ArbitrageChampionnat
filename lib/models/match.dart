import 'package:isar/isar.dart';

part 'match.g.dart';

@collection
class Match {
  Id get isarId => fastHash(id!);

  @Index(unique: true, replace: true)
  final String? id;
  final String player1;
  final String player2;
  final int score1;
  final int score2;
  final DateTime date;

  Match({
    this.id,
    required this.player1,
    required this.player2,
    required this.score1,
    required this.score2,
    required this.date,
  });
}

/// FNV-1a 64bit hash algorithm optimized for Dart strings
int fastHash(String string) {
  var hash = 0xcbf29ce484222325;
  var i = 0;
  while (i < string.length) {
    hash = hash ^ string.codeUnitAt(i++);
    hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
  }
  return hash;
}
