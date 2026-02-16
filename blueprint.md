# Blueprint de l'application de pointage de Tennis de Table

## Vue d'ensemble

Cette application permet de suivre les scores d'un match de tennis de table. Elle est conçue pour être simple et intuitive, avec une interface claire et facile à utiliser, et elle sauvegarde la progression pour pouvoir reprendre une partie interrompue.

## Style et Design

L'application utilise Material Design 3, avec un thème de couleurs bleu et blanc. La police principale est Roboto, avec Oswald pour les titres.

## Fonctionnalités

*   **Identification claire du service :**
    *   Le joueur qui sert a un fond **vert**.
    *   Le joueur qui reçoit a un fond **orange**.
    *   Cette mise en évidence visuelle facilite le suivi de la rotation automatique du service.
*   **Affichage de la manche en cours :** Le numéro de la manche actuelle est affiché au-dessus des équipes.
*   **Gestion des manches :** L'application détecte la fin d'une manche (à 11 points avec 2 points d'écart) et archive le score.
*   **Affichage des scores des manches :** Un cartouche affiche les scores des manches terminées.
*   **Automatisation du service :** Le service change automatiquement tous les deux points.
*   **Sélection de la partie :** Affiche la liste des parties possibles (simples et doubles).
*   **Persistance des données :** L'état de la partie est sauvegardé et restauré automatiquement.
*   **Écran de jeu unifié (`TableScreen`) :** Pointage, équipes et table sur un seul écran.
*   **Verrouillage de la configuration :** Les options se bloquent dès que la partie commence.
*   **Inversion des joueurs :** Un bouton "swap" permet d'inverser les équipes avant le match.

## Historique des changements récents

*   **Amélioration visuelle du service :** Le receveur est maintenant mis en évidence avec un fond orange, en plus du fond vert pour le serveur.
*   **Affichage du numéro de manche :** Le numéro de la manche en cours est maintenant affiché à l'écran.
*   **Ajout de la gestion des manches :** La logique de fin de manche est implémentée dans le `GameModel`.
*   **Création du cartouche des scores :** Un nouveau widget affiche les scores des manches terminées.
*   **Automatisation du service :** La logique de rotation du service est maintenant gérée par le `GameModel`.
*   **Implémentation de la persistance :** L'état de chaque partie est sauvegardé et restauré automatiquement.
*   **Verrouillage de la configuration :** La position des joueurs et le choix du premier serveur sont bloqués dès que la partie commence.
*   **Refonte de l'interface de jeu :** L'écran de pointage a été fusionné avec l'écran de présentation de la partie pour une expérience unifiée.
