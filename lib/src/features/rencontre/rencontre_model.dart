// lib/src/features/rencontre/rencontre_model.dart
//
// Modèle de données pour une rencontre avec les noms des équipes.
// Utilisé pour afficher les informations complètes d'une rencontre.

import 'package:myapp/src/features/core/data/database.dart';

class RencontreAvecEquipes {
  final Rencontre rencontre;
  final String nomEquipe1;
  final String nomEquipe2;
  final DateTime date;

  RencontreAvecEquipes({
    required this.rencontre,
    required this.nomEquipe1,
    required this.nomEquipe2,
    required this.date,
  });
}
