## Titre de l'Application : Gestionnaire de Tournoi de Ping-Pong

### Aperçu

Cette application a pour but de faciliter la gestion des feuilles de matchs lors de tournois de tennis de table. Elle permet de visualiser les parties, de les attribuer à des tables, et de suivre les scores en temps réel. L'application est conçue pour être simple et intuitive, avec une interface claire et des fonctionnalités ciblées.

### Fonctionnalités Clés

1.  **Gestion des Rencontres :** Créer, modifier et supprimer des rencontres, y compris les équipes et les joueurs associés.
2.  **Visualisation des Matchs :** Affiche la liste complète des matchs (simples et doubles) prévus, avec les noms des joueurs, leurs équipes, et les horaires.
3.  **Composition des Doubles :** Permet de sélectionner les joueurs qui composeront les équipes de double.
4.  **Attribution des Tables :** Glisser-déposer pour assigner un match à une table disponible.
5.  **Saisie des Scores :** Interface dédiée pour entrer les scores des sets pour chaque match.
6.  **Persistance des Données Locales :** Les données des parties et des joueurs sont sauvegardées localement sur l'appareil grâce à une base de données SQLite gérée par Drift.
7.  **Paramètres :** Permet de modifier les noms des joueurs.

### Structure du Projet

*   `lib/`
    *   `main.dart` : Point d'entrée de l'application.
    *   `src/`
        *   `features/`
            *   `core/data/database.dart` : Définition de la base de données locale avec Drift.
            *   `rencontre/` : Contient les écrans et la logique pour la gestion des rencontres (création, édition, détails, suppression).
            *   `match_selection/` : Contient les modèles, fournisseurs et écrans liés à la sélection des matchs.
            *   `doubles_composition/` : Écran pour la composition des équipes de double.
            *   `table_assignment/` : Logique pour l'assignation des tables.
            *   `score_entry/` : Interface pour la saisie des scores.
            *   `settings/` : Écran des paramètres.
        *   `widgets/` : Widgets réutilisables.
*   `assets/`
    *   `data/`
        *   `parties.json` : Fichier JSON contenant les données des matchs.
        *   `players.json` : Fichier JSON contenant les données des joueurs.

### Plan de Développement

**Phase 1 : Refactorisation et Amélioration (Terminée)**

*   **Remplacement du `TeamProvider` :** Le `TeamProvider` a été entièrement remplacé par le `PartieProvider` pour une gestion plus centralisée et cohérente des données des matchs.
*   **Centralisation du Thème :** La gestion du thème de l'application, y compris les couleurs, la typographie et les styles de composants, a été unifiée dans le fichier `main.dart`.
*   **Intégration des Polices Locales :** La dépendance `google_fonts` a été supprimée au profit de polices locales (`Oswald` et `Roboto`) pour améliorer les performances et garantir la disponibilité des polices hors ligne.
*   **Nettoyage du Code :** Les références inutilisées à `google_fonts` et les erreurs de thème (comme `TabBarTheme` au lieu de `TabBarThemeData`) ont été corrigées.

**Phase 2 : Amélioration de l'Expérience Utilisateur (Terminée)**

*   **Distinction Visuelle des Matchs :** Les cartes des matchs sur l'écran de sélection ont désormais des couleurs de fond distinctes pour différencier les simples (vert) des doubles (bleu).
*   **Interface de Pointage Unifiée :** L'écran de pointage pour les matchs simples inclut désormais l'icône "style" permettant d'afficher/masquer les actions de cartons.
*   **Sélection du Service Guidée pour les Doubles :** Mise en place de boîtes de dialogue et d'écrans dédiés pour guider la sélection du serveur et du receveur à chaque manche.

**Phase 3 : Persistance des données (Terminée)**

*   **Intégration de Drift :** Ajout de la base de données locale Drift pour la persistance des données.
*   **Définition du schéma :** Création des tables `Players`, `Parties`, et `Manches` dans `lib/src/features/core/data/database.dart`.
*   **Connexion au Provider :** Le `PartieProvider` a été refactorisé pour utiliser la base de données Drift.

**Phase 4 : Résolution de Bugs et Stabilisation (Terminée)**

*   **Correction Itérative :** Une série de corrections a été apportée pour résoudre de multiples erreurs de compilation liées à la manipulation des données avec Drift.
*   **Analyse du Schéma :** Après plusieurs tentatives infructueuses, le schéma de la base de données (`database.dart`) a été analysé en détail pour comprendre la source réelle des erreurs.
*   **Correction de la Logique d'Insertion :** La cause principale des erreurs était une utilisation incohérente des `Companions` de Drift. La logique a été corrigée en adoptant une méthode unifiée : l'utilisation systématique du constructeur `Value()` pour toutes les valeurs insérées dans la base de données.
*   **Contribution de l'Utilisateur :** La résolution finale a été rendue possible grâce à l'intervention directe de l'utilisateur, qui a lui-même corrigé le code, mettant en évidence l'erreur que l'IA n'arrivait pas à résoudre seule.
*   **Validation Finale :** Une analyse statique complète (`flutter analyze`) et une regénération des fichiers de la base de données (`build_runner`) ont été effectuées pour garantir l'absence totale d'erreurs et la parfaite synchronisation du code.

**Phase 5 : Gestion des Rencontres (Terminée)**

*   **Vérification de la Suppression :** La logique de suppression d'une rencontre existait déjà dans le `rencontre_provider.dart` mais n'était pas accessible depuis l'interface.
*   **Ajout du Bouton de Suppression :** Un bouton "Supprimer" a été ajouté à l'écran de détails d'une rencontre.
*   **Confirmation Utilisateur :** Une boîte de dialogue de confirmation a été mise en place pour prévenir les suppressions accidentelles.

**Phase 6 : Nouvelles Fonctionnalités (Futures Idées)**

*   **Mode Sombre :** Ajouter une option pour basculer entre un thème clair et un thème sombre.
*   **Synchronisation Cloud (Optionnel) :** Explorer l'intégration de Firebase Firestore pour permettre la synchronisation des données entre plusieurs appareils.
