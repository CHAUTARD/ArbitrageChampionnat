// lib/models/equipe_model.dart
//
// Modèle de données pour une équipe.
// Contient le nom de l'équipe et la liste des joueurs qui la composent.

import 'package:isar/isar.dart';
import 'package:myapp/models/player_model.dart';

part 'equipe_model.g.dart';

@collection
class Equipe {
  Id get isarId => fastHash(name);

  @Index(unique: true, replace: true)
  String name;

  @Backlink(to: "equipe")
  final players = IsarLinks<Player>();

  Equipe({required this.name});
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
