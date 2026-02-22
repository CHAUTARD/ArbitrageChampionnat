// lib/model/match.dart
import 'package:hive/hive.dart';
import 'package:myapp/models/equipe_model.dart';
import 'package:uuid/uuid.dart';

part 'match.g.dart';

@HiveType(typeId: 3)
class Match extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Equipe equipe1;

  @HiveField(2)
  final Equipe equipe2;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  int score1;

  @HiveField(5)
  int score2;

  Match({
    String? id,
    required this.equipe1,
    required this.equipe2,
    required this.date,
    int? score1,
    int? score2,
  }) : id = id ?? const Uuid().v4(),
       score1 = score1 ?? 0,
       score2 = score2 ?? 0;
}
