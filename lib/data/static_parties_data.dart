import 'package:myapp/models/partie_model.dart';

/// Retourne une liste statique de parties pré-définies.
///
/// Ces données étaient auparavant dans le fichier `assets/data/parties.json`.
/// Les intégrer directement dans le code Dart évite un chargement asynchrone.
List<Partie> getStaticParties() {
  const List<Map<String, dynamic>> partiesData = [
    // --- SIMPLES ---
    {
      "numero": 1,
      "team1PlayerIds": ["A"],
      "team2PlayerIds": ["W"],
      "arbitreId": "D",
    },
    {
      "numero": 2,
      "team1PlayerIds": ["B"],
      "team2PlayerIds": ["X"],
      "arbitreId": "Z",
    },
    {
      "numero": 3,
      "team1PlayerIds": ["C"],
      "team2PlayerIds": ["Y"],
      "arbitreId": "B",
    },
    {
      "numero": 4,
      "team1PlayerIds": ["D"],
      "team2PlayerIds": ["Z"],
      "arbitreId": "W",
    },
    {
      "numero": 5,
      "team1PlayerIds": ["A"],
      "team2PlayerIds": ["X"],
      "arbitreId": "C",
    },
    {
      "numero": 6,
      "team1PlayerIds": ["B"],
      "team2PlayerIds": ["W"],
      "arbitreId": "Y",
    },
    {
      "numero": 7,
      "team1PlayerIds": ["D"],
      "team2PlayerIds": ["Y"],
      "arbitreId": "A",
    },
    {
      "numero": 8,
      "team1PlayerIds": ["C"],
      "team2PlayerIds": ["Z"],
      "arbitreId": "X",
    },

    // --- DOUBLES ---
    {
      "numero": 9,
      "team1PlayerIds": ["A", "C"], // Correctif: liste de deux joueurs
      "team2PlayerIds": ["W", "Y"], // Correctif: liste de deux joueurs
      "arbitreId": "B",
    },
    {
      "numero": 10,
      "team1PlayerIds": ["B", "D"], // Correctif: liste de deux joueurs
      "team2PlayerIds": ["X", "Z"], // Correctif: liste de deux joueurs
      "arbitreId": "A",
    },
  ];

  return partiesData.map((data) => Partie.fromJson(data)).toList();
}
