# Blueprint de l'Application de Suivi de Scores

## Aperçu

Cette application Flutter, conçue pour l'arbitrage de championnat, permet de gérer intégralement une rencontre de tennis de table. Elle prend en charge la création de matchs, la saisie des joueurs, la composition automatique et manuelle des parties, et le suivi des scores en temps réel.

## Fonctionnalités

*   **Création de Rencontre :**
    *   Formulaire simple pour créer une nouvelle rencontre et définir les équipes.
*   **Gestion des Joueurs :**
    *   Saisie des joueurs pour chaque équipe avec détection automatique des classements.
*   **Composition des Parties :**
    *   **Automatique :** Génère les 14 parties de la rencontre en se basant sur la force des joueurs.
    *   **Manuelle :** Permet de composer les doubles manuellement si nécessaire.
*   **Feuille de Match Complète :**
    *   Affiche la liste des 14 parties de la rencontre.
    *   Indique le statut de chaque partie avec un code couleur pour une meilleure lisibilité.
    *   Affiche les noms des joueurs et de l'arbitre pour chaque partie.
    *   **Affichage des Scores :** Affiche le score final des parties terminées et validées.
    *   **Raccourci de Modification des Doubles :** Une icône dans la barre d'application permet de retourner à tout moment sur l'écran de configuration des doubles pour ajuster la composition des équipes.
*   **Écran de Pointage :**
    *   **Interface de Pointage Intuitive :** Un widget dédié affiche le score de la manche en cours avec de grands chiffres et des boutons `+` / `-` clairs pour une saisie rapide.
    *   **Tableau Récapitulatif des Manches :** Un tableau distinct, au format feuille de match, affiche l'historique des scores pour toutes les manches (M1 à M5), offrant une vue d'ensemble claire.
    *   **Gestion du Serveur et du Côté :**
        *   Affichage automatique du serveur actuel.
        *   Gestion du changement de côté entre les manches.
        *   Un bouton de changement de position des joueurs, mis en évidence, est disponible avant le début du match pour faciliter la configuration des doubles.
    *   **Validation par l'Arbitre :**
        *   Un bouton "Valider le Vainqueur" apparaît à la fin d'une partie.
        *   La validation enregistre le score final, le nom du vainqueur et verrouille la partie.
        *   Un message de confirmation demande à l'arbitre de ramener la tablette à la table d'arbitrage.

## Style et Conception

L'application utilise Material Design pour une interface utilisateur propre, moderne et cohérente. La conception est axée sur la simplicité et l'efficacité pour une utilisation en conditions de match. Les éléments interactifs clés, comme le bouton de changement de position des joueurs, sont mis en évidence pour une meilleure ergonomie.

## Gestion de Version

*   **Git & GitHub :** Le projet est suivi avec Git et sauvegardé sur un dépôt distant GitHub pour la sécurité et la collaboration.

## Plan Actuel

L'objectif est de continuer à améliorer l'expérience utilisateur, de stabiliser l'application et d'ajouter des fonctionnalités de sauvegarde et de partage des résultats.

### Étapes Réalisées
*   Mise en place de la structure de base de l'application.
*   Création des écrans de gestion de la rencontre, des joueurs et des parties.
*   Implémentation de la logique de composition automatique des parties.
*   Développement de l'écran de pointage avec gestion des manches.
*   Ajout de la fonctionnalité de validation des parties par l'arbitre.
*   **Refonte complète de l'interface de scoring pour une meilleure clarté et ergonomie.**
*   **Sauvegarde du projet sur un dépôt GitHub distant.**
