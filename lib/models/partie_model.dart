import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'partie_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class Partie extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  @JsonKey(defaultValue: 'Simple')
  final String type;

  @HiveField(2)
  @JsonKey(name: 'equipe1', defaultValue: [])
  final List<String> team1PlayerIds;

  @HiveField(3)
  @JsonKey(name: 'equipe2', defaultValue: [])
  final List<String> team2PlayerIds;

  @HiveField(4)
  @JsonKey(name: 'score_equipe_un', defaultValue: 0)
  final int scoreEquipeUn;

  @HiveField(5)
  @JsonKey(name: 'score_equipe_deux', defaultValue: 0)
  final int scoreEquipeDeux;

  @HiveField(6)
  @JsonKey(defaultValue: 'En cours')
  final String statut;

  @HiveField(7)
  @JsonKey(name: 'match_id')
  final String matchId;

  @HiveField(8)
  @JsonKey(name: 'arbitre')
  final String? arbitreId;

  Partie({
    String? id,
    required this.type,
    required this.team1PlayerIds,
    required this.team2PlayerIds,
    required this.scoreEquipeUn,
    required this.scoreEquipeDeux,
    required this.statut,
    required this.matchId,
    this.arbitreId,
  }) : id = id ?? const Uuid().v4();

  factory Partie.fromJson(Map<String, dynamic> json) => _$PartieFromJson(json);

  Map<String, dynamic> toJson() => _$PartieToJson(this);

  Partie copyWith({
    String? id,
    String? type,
    List<String>? team1PlayerIds,
    List<String>? team2PlayerIds,
    int? scoreEquipeUn,
    int? scoreEquipeDeux,
    String? statut,
    String? matchId,
    String? arbitreId,
  }) {
    return Partie(
      id: id ?? this.id,
      type: type ?? this.type,
      team1PlayerIds: team1PlayerIds ?? this.team1PlayerIds,
      team2PlayerIds: team2PlayerIds ?? this.team2PlayerIds,
      scoreEquipeUn: scoreEquipeUn ?? this.scoreEquipeUn,
      scoreEquipeDeux: scoreEquipeDeux ?? this.scoreEquipeDeux,
      statut: statut ?? this.statut,
      matchId: matchId ?? this.matchId,
      arbitreId: arbitreId ?? this.arbitreId,
    );
  }

  int get nombreJoueurs => type == 'Double' ? 4 : 2;
}
