import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'partie_model.g.dart';

@HiveType(typeId: 4)
class Partie extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int numero;

  @HiveField(2)
  final List<String> team1PlayerIds;

  @HiveField(3)
  final List<String> team2PlayerIds;

  @HiveField(4)
  final String? arbitreId;

  @HiveField(5)
  final int? scoreEquipeUn;

  @HiveField(6)
  final int? scoreEquipeDeux;

  Partie({
    String? id,
    required this.numero,
    required this.team1PlayerIds,
    required this.team2PlayerIds,
    this.arbitreId,
    this.scoreEquipeUn,
    this.scoreEquipeDeux,
  }) : id = id ?? const Uuid().v4();

  factory Partie.fromJson(Map<String, dynamic> json) {
    return Partie(
      numero: json['numero'] as int,
      team1PlayerIds: (json['team1PlayerIds'] as List<dynamic>).map((e) => e as String).toList(),
      team2PlayerIds: (json['team2PlayerIds'] as List<dynamic>).map((e) => e as String).toList(),
      arbitreId: json['arbitreId'] as String?,
      scoreEquipeUn: json['scoreEquipeUn'] as int?,
      scoreEquipeDeux: json['scoreEquipeDeux'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'numero': numero,
        'team1PlayerIds': team1PlayerIds,
        'team2PlayerIds': team2PlayerIds,
        'arbitreId': arbitreId,
        'scoreEquipeUn': scoreEquipeUn,
        'scoreEquipeDeux': scoreEquipeDeux,
      };

  Partie copyWith({
    String? id,
    int? numero,
    List<String>? team1PlayerIds,
    List<String>? team2PlayerIds,
    String? arbitreId,
    int? scoreEquipeUn,
    int? scoreEquipeDeux,
  }) {
    return Partie(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      team1PlayerIds: team1PlayerIds ?? this.team1PlayerIds,
      team2PlayerIds: team2PlayerIds ?? this.team2PlayerIds,
      arbitreId: arbitreId ?? this.arbitreId,
      scoreEquipeUn: scoreEquipeUn ?? this.scoreEquipeUn,
      scoreEquipeDeux: scoreEquipeDeux ?? this.scoreEquipeDeux,
    );
  }
}
