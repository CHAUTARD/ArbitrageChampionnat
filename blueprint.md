# Blueprint de l'application de suivi de scores

## Aperçu

Cette application Flutter, conçue pour l'arbitrage de championnat de tennis de table, couvre tout le cycle d'une rencontre : création des matchs, saisie des joueurs, génération/composition des parties, pointage en temps réel, validation officielle et restitution sur feuille de match.

## Fonctionnalités principales

- Création de rencontre et gestion des équipes.
- Saisie des joueurs par équipe.
- Composition des 14 parties (simples + doubles), avec gestion spécifique des doubles.
- Feuille de match complète : liste des parties, arbitre, score final, statut.
- Écran de scoring dédié pour chaque partie.

## Règles métier de scoring (implémentées)

### 1) Règles de manche

- Une manche est gagnée uniquement si :
    - le score du vainqueur est strictement supérieur à 10,
    - et l'écart est d'au moins 2 points.
- Le format de partie est en 3 manches gagnantes (best of 5).
- Le total de manches est limité à 5 (M1 à M5).

### 2) Passage automatique des manches

- Dès qu'une manche est gagnée, la manche suivante est créée automatiquement à 0-0.
- La création automatique s'arrête si la partie est déjà gagnée (3 manches) ou si 5 manches sont déjà atteintes.
- Une manche terminée n'est plus modifiable : les boutons + / - sont désactivés pour cette manche.

### 3) Validation de partie

- Le bouton Valider la partie est activé uniquement lorsqu'un vainqueur est effectivement désigné (3 manches gagnées).
- À la validation, les données suivantes sont enregistrées :
    - score équipe 1,
    - score équipe 2,
    - identifiant du vainqueur,
    - statut validé.
- Une fois la partie validée, le bouton Valider la partie disparaît de l'écran de scoring.

### 4) Verrouillage avant/après démarrage

- Dès que le premier point de la première manche est marqué :
    - il n'est plus possible de changer le premier serveur,
    - il n'est plus possible d'inverser les joueurs,
    - il n'est plus possible d'utiliser l'inversion manuelle des côtés.

### 5) Règles de service et affichage raquette

- Le serveur est défini au départ par le gagnant du toss.
- Pendant une manche :
    - le service alterne tous les 2 points tant que le score cumulé est inférieur à 10-10,
    - puis alterne à chaque point à partir de 10-10.
- Le nom des joueurs s'inverse visuellement à chaque manche.
- Le côté du premier serveur alterne également d'une manche à l'autre (cohérent avec l'inversion de côté).
- L'indicateur raquette se place toujours sur le joueur affiché sur la table pour le côté qui sert.

## Règles UI et ergonomie (implémentées)

### Écran de scoring

- Titre du bandeau :
    - Partie X à gauche,
    - arbitre à droite avec pictogramme.
- Gestion des débordements du bandeau : texte tronqué avec ellipsis pour éviter les overflow.
- Contrôles de score en boutons ronds + / - pour une interaction tactile claire.

### Tableau des manches

- Tableau prévu sur 5 colonnes de manches (M1 à M5).
- Scroll horizontal activé pour petits écrans.
- Version compacte du tableau : marges/espacements réduits, hauteur de ligne compacte, colonne Nom tronquée pour limiter le scroll.

### Liste des parties

- Après validation, le score final est affiché.
- Le gagnant est mis en gras dans la carte de partie (détection via winnerId).

## Style et conception

L'application suit Material Design avec un objectif de lisibilité en situation d'arbitrage : actions critiques visibles, feedback immédiat, et contraintes métier appliquées directement dans l'interface.

## Gestion de version

- Projet versionné avec Git et synchronisé sur GitHub.

## État actuel

Le socle fonctionnel de scoring et validation est en place et aligné avec les règles métier ci-dessus. Les prochaines évolutions portent prioritairement sur le confort d'utilisation (lisibilité, rapidité de saisie, robustesse en conditions réelles de match).
