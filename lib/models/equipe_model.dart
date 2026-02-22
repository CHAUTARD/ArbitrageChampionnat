// lib/models/equipe_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:myapp/models/player_model.dart';

part 'equipe_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 0)
class Equipe extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final List<Player> joueurs;

  Equipe({this.id, required this.nom, this.joueurs = const []});

  factory Equipe.fromJson(Map<String, dynamic> json) => _$EquipeFromJson(json);

  Map<String, dynamic> toJson() => _$EquipeToJson(this);

  Equipe copyWith({String? id, String? nom, List<Player>? joueurs}) {
    return Equipe(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      joueurs: joueurs ?? this.joueurs,
    );
  }
}
