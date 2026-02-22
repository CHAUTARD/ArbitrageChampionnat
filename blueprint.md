
# Aperçu du Projet

Ceci est une application Flutter pour la gestion des scores de tournois. Elle permet aux utilisateurs de créer, suivre и afficher les scores des matchs. L'application utilise Hive pour le stockage local et `provider` pour la gestion de l'état.

# Fonctionnalités Implémentées

*   **Gestion du Thème :** L'application prend en charge les modes de thème clair, sombre et système. Un bouton dans la barre d'applications permet aux utilisateurs de basculer entre les thèmes.
*   **Gestion des Matchs :**
    *   Afficher une liste de matchs.
    *   Les données des matchs sont stockées localement à l'aide de Hive.
*   **Modèles :** L'application utilise les modèles de données suivants :
    *   `Game`
    *   `Manche`
    *   `Match`
    *   `Partie`
    *   `Player`

# Plan Actuel

1.  **Localiser l'application en français.**
2.  Corriger l'implémentation du thème pour utiliser correctement le package `provider`.
3.  S'assurer que le `ThemeToggleButton` fonctionne comme prévu.
