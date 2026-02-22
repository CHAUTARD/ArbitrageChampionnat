import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/models/partie_model.dart';

part 'match.g.dart';

@JsonSerializable()
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
  @JsonKey(name: 'equipe_un')
  final String equipeUn;

  @HiveField(7)
  @JsonKey(name: 'equipe_deux')
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

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);

  Map<String, dynamic> toJson() => _$MatchToJson(this);
}
