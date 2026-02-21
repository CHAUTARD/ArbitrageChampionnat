import 'package:isar/isar.dart';
import 'package:myapp/models/equipe_model.dart';

part 'player_model.g.dart';

@collection
class Player {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  final String id;
  final String name;

  final equipe = IsarLink<Equipe>();

  Player({required this.id, required this.name});
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
