import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'player_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 5)
class Player extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String equipe;

  @HiveField(3)
  final String lettre;

  Player({
    String? id,
    this.name = 'Joueur inconnu',
    required this.equipe,
    required this.lettre,
  }) : id = id ?? const Uuid().v4();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
