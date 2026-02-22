import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:myapp/models/equipe_model.dart';

part 'player_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 5)
class Player extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final Equipe equipe;

  Player({
    String? id,
    required this.name,
    required this.equipe,
  }) : id = id ?? const Uuid().v4();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
