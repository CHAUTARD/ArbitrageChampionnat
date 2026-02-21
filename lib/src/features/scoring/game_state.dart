import 'package:json_annotation/json_annotation.dart';

part 'game_state.g.dart';

@JsonSerializable()
class GameState {
  final int team1Score;
  final int team2Score;
  final bool isSwapped;
  final String? serverId;
  final String? receiverId;
  final List<String> setScores; // Added this line

  GameState({
    required this.team1Score,
    required this.team2Score,
    required this.isSwapped,
    this.serverId,
    this.receiverId,
    this.setScores = const [], // Added this line
  });

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}
