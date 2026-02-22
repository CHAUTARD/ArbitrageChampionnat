# Aperçu du Projet

Ceci est une application Flutter pour la gestion des scores de tournois de tennis de table. Elle permet aux utilisateurs de créer, suivre et afficher les scores des matchs, y compris les parties simples et doubles. L'application utilise Hive pour le stockage local et `provider` pour la gestion de l'état et du thème.

# Fonctionnalités Implémentées

*   **Gestion du Thème :** L'application prend en charge les modes de thème clair, sombre et système. Un bouton dans la barre d'applications permet aux utilisateurs de basculer entre les thèmes.
*   **Gestion des Matchs :**
    *   Afficher une liste de matchs avec les scores totaux.
    *   Créer, modifier et supprimer des matchs.
    *   Les données des matchs sont stockées localement à l'aide de Hive.
*   **Gestion des Parties :**
    *   Afficher une liste des parties pour chaque match.
    *   Naviguer vers un écran de tableau de pointage pour chaque partie.
*   **Tableau de Pointage :**
    *   Écrans de tableau de pointage distincts pour les parties simples et doubles.
    *   Incrémenter les scores pour chaque équipe/joueur.
*   **Modèles :** L'application utilise les modèles de données suivants :
    *   `Game`
    *   `Manche`
    *   `Match`
    *   `Partie`
    *   `Player`
*   **Localisation :** L'application est localisée en français.

# Plan Actuel

*   **Refactoring:** Renommage de `equipe1`/`equipe2` et `score1`/`score2` en `equipeUn`/`equipeDeux` et `scoreUn`/`scoreDeux` respectivement dans plusieurs fichiers pour plus de cohérence.
*   **Corrections de Bugs:**
    *   Résolution des erreurs dans `lib/src/features/match_selection/match_card.dart` en calculant correctement les scores totaux à partir des parties individuelles.
    *   Correction des erreurs dans `lib/src/features/scoring/table_screen.dart` en supprimant un paramètre `arbitre` non défini et en ajoutant le paramètre `equipe` requis au constructeur `Player`.
    *   Correction du paramètre `equipe` manquant dans `lib/src/features/match_selection/partie_list_screen.dart` et `lib/src/features/scoring/manche_table.dart`.
*   **Navigation:**
    *   Mise à jour de la navigation dans `lib/src/features/match_selection/partie_list_screen.dart` pour utiliser `TableScreen`.
    *   Ajout de la récupération des données des joueurs à `lib/src/features/scoring/table_screen.dart` pour garantir que les données correctes sont transmises à `SimpleTableScreen` et `DoubleTableScreen`.
*   **Dépendances:**
    *   Ajout de `flutter_localizations` à `pubspec.yaml`.
    *   Ajout de `initialize_localizations.dart` à `lib/` pour configurer les localisations.
