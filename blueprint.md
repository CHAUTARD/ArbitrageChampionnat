# Blueprint de l'application de pointage de Tennis de Table

## Vue d'ensemble

Je souhaite un écran de pointage pour le tennis de table qui fonctionne comme une table d'arbitrage numérique et intelligente. Il doit être unifié et afficher toutes les informations essentielles sur un seul écran pour une gestion de match fluide et intuitive.

## Style et Design

L'application utilise Material Design 3, avec une palette de couleurs centrée sur le vert (table), le bleu et le rouge (joueurs), et des tons neutres. La police principale est Roboto, avec Oswald pour les titres et les scores pour une meilleure lisibilité.

## Fonctionnalités Clés de l'Écran de Pointage

### 1. Affichage de la partie en cours
L'en-tête de l'écran affiche clairement le nom de la partie sélectionnée (ex: "Partie N° 1").

### 2. Disposition des Joueurs et Contrôles
Un tableau horizontal en haut de l'écran affiche les joueurs et le bouton de changement de côté en trois colonnes :
*   **Colonne 1 (Joueur 1) :** Un bouton affichant le nom du joueur. Si ce joueur est le serveur, le bouton a un fond vert clair et une icône de raquette.
*   **Colonne 2 (Action) :** Un bouton "Changer de côté" qui inverse la position des équipes à l'écran.
*   **Colonne 3 (Joueur 2) :** Idem que la colonne 1, pour le deuxième joueur (ou la deuxième équipe).

### 3. Représentation Visuelle de la Table
Sous les noms des joueurs, une représentation graphique d'une table de tennis de table est affichée : un rectangle vert avec une bordure blanche, un trait blanc au milieu, et une ligne représentant le filet.

### 4. Gestion du Pointage
*   Sous la table visuelle, les contrôles de score sont alignés sur les deux moitiés de la table.
*   Chaque côté dispose d'un affichage proéminent du score actuel et de boutons `+` et `-` pour l'ajuster.

### 5. Tableau des Scores des Manches
En bas de l'écran, un tableau affiche les résultats des manches terminées, avec une capacité de 5 manches.

### 6. Logique de Jeu Automatisée
*   **Suivi Intelligent du Service :** L'application sait en permanence qui sert et qui reçoit. Le service change automatiquement tous les deux points.
*   **Gestion des Manches :** L'application détecte la fin d'une manche (à 11 points avec 2 points d'écart), enregistre le score dans le tableau des manches, et réinitialise le pointage pour la nouvelle manche.

## Résumé de l'Objectif

L'objectif est d'avoir un écran de pointage **unifié et intelligent**. Il ne se contente pas de compter les points ; il comprend les règles du service, simule la disposition d'une vraie table et présente l'information de manière claire pour rendre l'arbitrage aussi simple et sans erreur que possible.
