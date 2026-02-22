// lib/models/partie_model.dart
// Ce fichier définit le modèle de données pour une "Partie".
// Il utilise Hive pour la persistance des données et json_serializable pour la sérialisation.

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
  @JsonKey(name: 'joueur_un_id')
  final String joueurUnId;

  @HiveField(3)
  @JsonKey(name: 'joueur_deux_id')
  final String joueurDeuxId;

  @HiveField(4)
  @JsonKey(name: 'equipe_un_id')
  final String equipeUnId;

  @HiveField(5)
  @JsonKey(name: 'equipe_deux_id')
  final String equipeDeuxId;

  @HiveField(6)
  @JsonKey(name: 'score_equipe_un', defaultValue: 0)
  final int scoreEquipeUn;

  @HiveField(7)
  @JsonKey(name: 'score_equipe_deux', defaultValue: 0)
  final int scoreEquipeDeux;

  @HiveField(8)
  @JsonKey(defaultValue: 'En cours')
  final String statut;

  @HiveField(9)
  @JsonKey(name: 'match_id')
  final String matchId;

  @HiveField(10)
  @JsonKey(name: 'nombre_manches', defaultValue: 3)
  final int nombreManches;

  Partie({
    String? id,
    required this.type,
    required this.joueurUnId,
    required this.joueurDeuxId,
    required this.equipeUnId,
    required this.equipeDeuxId,
    required this.scoreEquipeUn,
    required this.scoreEquipeDeux,
    required this.statut,
    required this.matchId,
    this.nombreManches = 3,
  }) : id = id ?? const Uuid().v4();

  factory Partie.fromJson(Map<String, dynamic> json) => _$PartieFromJson(json);

  Map<String, dynamic> toJson() => _$PartieToJson(this);

  Partie copyWith({
    String? id,
    String? type,
    String? joueurUnId,
    String? joueurDeuxId,
    String? equipeUnId,
    String? equipeDeuxId,
    int? scoreEquipeUn,
    int? scoreEquipeDeux,
    String? statut,
    String? matchId,
    int? nombreManches,
  }) {
    return Partie(
      id: id ?? this.id,
      type: type ?? this.type,
      joueurUnId: joueurUnId ?? this.joueurUnId,
      joueurDeuxId: joueurDeuxId ?? this.joueurDeuxId,
      equipeUnId: equipeUnId ?? this.equipeUnId,
      equipeDeuxId: equipeDeuxId ?? this.equipeDeuxId,
      scoreEquipeUn: scoreEquipeUn ?? this.scoreEquipeUn,
      scoreEquipeDeux: scoreEquipeDeux ?? this.scoreEquipeDeux,
      statut: statut ?? this.statut,
      matchId: matchId ?? this.matchId,
      nombreManches: nombreManches ?? this.nombreManches,
    );
  }

  int get nombreJoueurs => type == 'Double' ? 4 : 2;
}
