import 'package:myapp/models/partie_model.dart';

/// Retourne une liste de parties avec les identifiants des joueurs préfixés par l'ID du match.
List<Partie> getStaticParties(String matchId) {
  final List<Map<String, dynamic>> partiesData = [
    // --- SIMPLES ---
    {
      "numero": 1,
      "team1PlayerIds": ['A'],
      "team2PlayerIds": ['W'],
      "arbitreId": 'D',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 2,
      "team1PlayerIds": ['B'],
      "team2PlayerIds": ['X'],
      "arbitreId": 'Z',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 3,
      "team1PlayerIds": ['C'],
      "team2PlayerIds": ['Y'],
      "arbitreId": 'B',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 4,
      "team1PlayerIds": ['D'],
      "team2PlayerIds": ['Z'],
      "arbitreId": 'W',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 5,
      "team1PlayerIds": ['A'],
      "team2PlayerIds": ['X'],
      "arbitreId": 'C',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 6,
      "team1PlayerIds": ['B'],
      "team2PlayerIds": ['W'],
      "arbitreId": 'Y',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 7,
      "team1PlayerIds": ['D'],
      "team2PlayerIds": ['Y'],
      "arbitreId": 'A',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 8,
      "team1PlayerIds": ['C'],
      "team2PlayerIds": ['Z'],
      "arbitreId": 'X',
      "status": "A venir",
      "isEditable": false,
    },

    // --- DOUBLES ---
    {
      "numero": 9,
      "team1PlayerIds": ['A', 'B'],
      "team2PlayerIds": ['W', 'X'],
      "arbitreId": 'B',
      "status": "A venir",
      "isEditable": true,
    },
    {
      "numero": 10,
      "team1PlayerIds": [],
      "team2PlayerIds": [],
      "arbitreId": 'A',
      "status": "A venir",
      "isEditable": true,
    },
    {
      "numero": 11,
      "team1PlayerIds": ['A'],
      "team2PlayerIds": ['Z'],
      "arbitreId": 'B',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 12,
      "team1PlayerIds": ['C'],
      "team2PlayerIds": ['W'],
      "arbitreId": 'D',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 13,
      "team1PlayerIds": ['B'],
      "team2PlayerIds": ['Y'],
      "arbitreId": 'X',
      "status": "A venir",
      "isEditable": false,
    },
    {
      "numero": 14,
      "team1PlayerIds": ['D'],
      "team2PlayerIds": ['X'],
      "arbitreId": 'Y',
      "status": "A venir",
      "isEditable": false,
    },
  ];

  // Préfixe les IDs avec l'ID du match pour garantir l'unicité
  final updatedParties = partiesData.map((data) {
    final team1Ids = (data['team1PlayerIds'] as List<dynamic>)
        .map((id) => id.toString()) // Convert each element to String
        .map((id) => '$matchId-$id')
        .toList();
    final team2Ids = (data['team2PlayerIds'] as List<dynamic>)
        .map((id) => id.toString()) // Convert each element to String
        .map((id) => '$matchId-$id')
        .toList();
    final arbitreId = data['arbitreId'] != null
        ? '$matchId-${data['arbitreId']}'
        : null;

    return {
      ...data,
      'team1PlayerIds': team1Ids,
      'team2PlayerIds': team2Ids,
      'arbitreId': arbitreId,
    };
  }).toList();

  return updatedParties.map((data) => Partie.fromJson(data)).toList();
}
