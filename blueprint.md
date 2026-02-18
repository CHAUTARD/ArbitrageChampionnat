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

**Phase 1 : Refactorisation et Amélioration (Terminée)**

*   **Remplacement du `TeamProvider` :** Le `TeamProvider` a été entièrement remplacé par le `PartieProvider` pour une gestion plus centralisée et cohérente des données des matchs.
*   **Centralisation du Thème :** La gestion du thème de l'application, y compris les couleurs, la typographie et les styles de composants, a été unifiée dans le fichier `main.dart`.
*   **Intégration des Polices Locales :** La dépendance `google_fonts` a été supprimée au profit de polices locales (`Oswald` et `Roboto`) pour améliorer les performances et garantir la disponibilité des polices hors ligne.
*   **Nettoyage du Code :** Les références inutilisées à `google_fonts` et les erreurs de thème (comme `TabBarTheme` au lieu de `TabBarThemeData`) ont été corrigées, résultant en un code plus propre et plus stable.

**Phase 2 : Amélioration de l'Expérience Utilisateur (À venir)**

*   **Animations et Feedback Visuel :** Introduire des animations subtiles pour rendre l'interface plus dynamique (par exemple, lors de l'apparition des cartes de match) et améliorer le feedback visuel sur les interactions utilisateur.
*   **Optimisation de l'Affichage :** Assurer que l'interface s'adapte de manière fluide à différentes tailles d'écran.

**Phase 3 : Nouvelles Fonctionnalités (Futures Idées)**

*   **Mode Sombre :** Ajouter une option pour basculer entre un thème clair et un thème sombre.
*   **Persistance des Données :** Implémenter une solution de stockage local (comme `shared_preferences` ou une base de données locale) pour sauvegarder l'état de l'application.
*   **Notifications en Temps Réel :** Explorer l'intégration de notifications pour informer les utilisateurs des événements importants (début de match, résultats, etc.).
