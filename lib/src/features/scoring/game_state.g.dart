// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameState _$GameStateFromJson(Map<String, dynamic> json) => GameState(
      team1Score: json['team1Score'] as int,
      team2Score: json['team2Score'] as int,
      isSwapped: json['isSwapped'] as bool,
      serverId: json['serverId'] as String?,
      receiverId: json['receiverId'] as String?,
      setScores: (json['setScores'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$GameStateToJson(GameState instance) => <String, dynamic>{
      'team1Score': instance.team1Score,
      'team2Score': instance.team2Score,
      'isSwapped': instance.isSwapped,
      'serverId': instance.serverId,
      'receiverId': instance.receiverId,
      'setScores': instance.setScores,
    };
