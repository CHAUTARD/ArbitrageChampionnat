import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'partie_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Partie extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final int numero;

  @HiveField(2)
  List<String> team1PlayerIds;

  @HiveField(3)
  List<String> team2PlayerIds;

  @HiveField(4)
  String? arbitreId;

  @HiveField(5)
  int? scoreEquipeUn;

  @HiveField(6)
  int? scoreEquipeDeux;

  @HiveField(7)
  String status;

  @HiveField(8)
  final bool isEditable;

  Partie({
    this.id,
    required this.numero,
    required this.team1PlayerIds,
    required this.team2PlayerIds,
    this.arbitreId,
    this.scoreEquipeUn,
    this.scoreEquipeDeux,
    required this.status,
    required this.isEditable,
  });

  String get type => team1PlayerIds.length == 1 ? 'Simple' : 'Double';

  factory Partie.fromJson(Map<String, dynamic> json) => _$PartieFromJson(json);
  Map<String, dynamic> toJson() => _$PartieToJson(this);

  Partie copyWith({
    String? id,
    int? numero,
    List<String>? team1PlayerIds,
    List<String>? team2PlayerIds,
    String? arbitreId,
    int? scoreEquipeUn,
    int? scoreEquipeDeux,
    String? status,
    bool? isEditable,
  }) {
    return Partie(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      team1PlayerIds: team1PlayerIds ?? this.team1PlayerIds,
      team2PlayerIds: team2PlayerIds ?? this.team2PlayerIds,
      arbitreId: arbitreId ?? this.arbitreId,
      scoreEquipeUn: scoreEquipeUn ?? this.scoreEquipeUn,
      scoreEquipeDeux: scoreEquipeDeux ?? this.scoreEquipeDeux,
      status: status ?? this.status,
      isEditable: isEditable ?? this.isEditable,
    );
  }
}
