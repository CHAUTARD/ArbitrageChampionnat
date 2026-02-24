# Blueprint de l'Application de Suivi de Scores de Tennis

## Aperçu

Cette application Flutter, conçue pour l'arbitrage de championnat, permet de gérer intégralement une rencontre de tennis de table. Elle prend en charge la création de matchs, la saisie des joueurs, la composition automatique et manuelle des parties, et le suivi des scores en temps réel.

## Fonctionnalités

*   **Création de Match :** Permet de créer des rencontres en spécifiant le type, la compétition et les équipes.
*   **Saisie des Joueurs :** Un écran dédié pour entrer les noms des 4 joueurs de chaque équipe.
*   **Saisie Automatique (Mode Débogage) :** En mode débogage, les noms des équipes et des joueurs sont automatiquement pré-remplis pour accélérer les tests.
*   **Assignation Automatique des Simples :** Les 8 premières parties (simples) sont automatiquement configurées avec les joueurs et les arbitres respectifs dès la saisie des joueurs.
*   **Composition Intelligente des Doubles :**
    *   Un écran dédié (`ConfigureDoublesScreen`) centralise la composition des deux parties de double.
    *   L'utilisateur compose la première partie de double (n°9), et la seconde (n°10) est automatiquement constituée avec les joueurs restants de chaque équipe.
    *   Ce processus garantit une composition rapide et sans erreur des équipes de double.
*   **Feuille de Match Complète :**
    *   Affiche la liste des 14 parties de la rencontre.
    *   Indique le statut de chaque partie avec un code couleur pour une meilleure lisibilité.
    *   Affiche les noms des joueurs et de l'arbitre pour chaque partie.
*   **Écran de Pointage :**
    *   Interface claire pour incrémenter/décrémenter les points.
    *   Gestion et navigation entre les manches.
*   **Flux de Navigation Optimisé :**
    *   Le parcours utilisateur est linéaire et intuitif : `Création de rencontre` -> `Saisie des joueurs` -> `Configuration des doubles` -> `Feuille des parties`.
    *   La navigation est conçue pour guider l'arbitre à chaque étape, minimisant les actions manuelles.

## Style et Conception

L'application utilise Material Design pour une interface utilisateur propre, moderne et cohérente sur toutes les plateformes. La conception est axée sur la simplicité et l'efficacité pour une utilisation en conditions de match.

## Plan Actuel

L'objectif est de continuer à améliorer l'expérience utilisateur, de stabiliser l'application et d'ajouter des fonctionnalités de sauvegarde et de partage des résultats.

### Étapes Réalisées

1.  **Mise en place de la structure de base :** Création des modèles, des services et des écrans initiaux.
2.  **Affichage des 14 parties :** Implémentation de la logique pour générer et afficher la feuille de match complète.
3.  **Assignation automatique des simples :** Développement de l'algorithme d'assignation des joueurs et arbitres.
4.  **Flux de création et de saisie :** Optimisation de la navigation depuis la création du match jusqu'à l'affichage des parties.
5.  **Développement de l'écran de pointage :** Création de l'interface de saisie des scores.
6.  **Composition intelligente des doubles :** Création de l'écran de configuration centralisée pour les doubles, simplifiant drastiquement le processus.
7.  **Corrections et Améliorations :** Résolution continue de bugs, amélioration de la robustesse et correction d'erreurs de compilation comme l'ajout de la méthode `copyWith`.
