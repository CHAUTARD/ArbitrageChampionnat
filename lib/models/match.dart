import 'package:hive/hive.dart';
import 'package:myapp/models/partie_model.dart';

part 'match.g.dart';

@HiveType(typeId: 3)
class Match extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final List<Partie> parties;

  @HiveField(5)
  final String competitionId;

  @HiveField(6)
  final String equipeUn;

  @HiveField(7)
  final String equipeDeux;

  Match({
    required this.id,
    required this.type,
    required this.status,
    required this.date,
    required this.parties,
    required this.competitionId,
    required this.equipeUn,
    required this.equipeDeux,
  });

  Match copyWith({
    String? id,
    String? type,
    String? status,
    DateTime? date,
    List<Partie>? parties,
    String? competitionId,
    String? equipeUn,
    String? equipeDeux,
  }) {
    return Match(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      date: date ?? this.date,
      parties: parties ?? this.parties,
      competitionId: competitionId ?? this.competitionId,
      equipeUn: equipeUn ?? this.equipeUn,
      equipeDeux: equipeDeux ?? this.equipeDeux,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'status': status,
    'date': date.toIso8601String(),
    'parties': parties.map((p) => p.toJson()).toList(),
    'competitionId': competitionId,
    'equipe_un': equipeUn,
    'equipe_deux': equipeDeux,
  };
}
