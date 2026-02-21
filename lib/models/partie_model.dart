// lib/src/features/match_selection/partie_model.dart
//
// Modèle de données pour une partie (match).
// Contient les informations sur les joueurs, l'arbitre, l'état du match, etc.

import 'package:isar/isar.dart';
import 'package:myapp/models/player_model.dart';

part 'partie_model.g.dart';

@collection
class Partie {
  Id get isarId => fastHash(id);

  @Index(unique: true, replace: true)
  final String id;
  final int rencontreId;
  final int numeroPartie;
  final String? arbitreId;
  final String? arbitreName;
  bool isFinished;

  final team1Players = IsarLinks<Player>();
  final team2Players = IsarLinks<Player>();

  Partie({
    required this.id,
    required this.rencontreId,
    required this.numeroPartie,
    this.arbitreId,
    this.arbitreName,
    this.isFinished = false,
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
