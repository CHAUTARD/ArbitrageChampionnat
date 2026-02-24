import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/models/partie_model.dart';

part 'manche_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2) // Correction du typeId
class Manche extends HiveObject {
  @HiveField(0)
  final Partie partie;

  @HiveField(1)
  int scoreTeam1;

  @HiveField(2)
  int scoreTeam2;

  @HiveField(3)
  final bool isFinished;

  Manche({
    required this.partie,
    this.scoreTeam1 = 0,
    this.scoreTeam2 = 0,
    this.isFinished = false,
  });

  factory Manche.fromJson(Map<String, dynamic> json) => _$MancheFromJson(json);
  Map<String, dynamic> toJson() => _$MancheToJson(this);
}
