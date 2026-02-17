## Titre de l'Application : Gestionnaire de Tournoi de Ping-Pong

### Aperçu

Cette application a pour but de faciliter la gestion des feuilles de matchs lors de tournois de tennis de table. Elle permet de visualiser les parties, de les attribuer à des tables, et de suivre les scores en temps réel. L'application est conçue pour être simple et intuitive, avec une interface claire et des fonctionnalités ciblées.

### Fonctionnalités Clés

1.  **Visualisation des Matchs :** Affiche la liste complète des matchs (simples et doubles) prévus, avec les noms des joueurs, leurs équipes, et les horaires.
2.  **Composition des Doubles :** Permet de sélectionner les joueurs qui composeront les équipes de double.
3.  **Attribution des Tables :** Glisser-déposer pour assigner un match à une table disponible.
4.  **Saisie des Scores :** Interface dédiée pour entrer les scores des sets pour chaque match.
5.  **Suivi en Temps Réel :** Mise à jour automatique des informations sur tous les appareils connectés.
6.  **Paramètres :** Permet de modifier les noms des joueurs.

### Structure du Projet

*   `lib/`
    *   `main.dart` : Point d'entrée de l'application.
    *   `src/`
        *   `features/`
            *   `match_selection/` : Contient les modèles, fournisseurs et écrans liés à la sélection des matchs.
            *   `doubles_composition/` : Écran pour la composition des équipes de double.
            *   `table_assignment/` : Logique pour l'assignation des tables.
            *   `score_entry/` : Interface pour la saisie des scores.
            *   `settings/` : Écran des paramètres.
        *   `widgets/` : Widgets réutilisables.
        *   `services/` : Services pour la gestion des données.
*   `assets/`
    *   `data/`
        *   `parties.json` : Fichier JSON contenant les données des matchs.
        *   `players.json` : Fichier JSON contenant les données des joueurs.

### Plan de Développement Actuel

*   **Tâche en cours :** Finaliser la suppression du `TeamProvider` et le remplacer par le `PartieProvider`.
*   **Prochaines Étapes :**
    1.  Nettoyer le code et supprimer les dépendances inutilisées.
    2.  Améliorer l'interface utilisateur pour une meilleure expérience.
    3.  Ajouter la persistance des données pour que les modifications soient sauvegardées.
