# Blueprint de l'Application de Suivi de Scores de Tennis

## Aperçu

Cette application Flutter permet de suivre les scores des matchs de tennis, qu'il s'agisse de simples ou de doubles. Elle offre une interface claire pour enregistrer les points, gérer les manches et afficher les scores en temps réel.

## Fonctionnalités

*   **Création de Match :** Permet de créer des matchs en simple ou en double en sélectionnant les joueurs.
*   **Saisie Automatique (Mode Débogage) :** En mode débogage, les noms des équipes et des joueurs sont automatiquement pré-remplis pour accélérer les tests.
*   **Flux de Navigation Amélioré :** La navigation a été optimisée :
    *   Après la création d'une rencontre, l'utilisateur est directement redirigé vers l'écran des fiches de partie.
    *   Un bouton de retour a été ajouté à l'écran "Feuille des parties" pour revenir facilement à la liste des rencontres.
*   **Affichage Corrigé des Noms :** L'application affiche désormais correctement les noms des joueurs et des arbitres sur les fiches de partie.
*   **Tableau de Score :** Affiche le score de la manche en cours pour chaque équipe.
*   **Gestion des Manches :** Permet de naviguer entre les différentes manches d'un match.
*   **Saisie des Scores :** Des boutons permettent d'incrémenter et de décrémenter le score de chaque équipe.
*   **Feuille de Match :** Un écran dédié affiche la feuille de match pour une partie donnée.
*   **Affichage des 14 Parties :** L'application génère et affiche systématiquement les 14 parties d'une rencontre.
*   **Statut des Parties :** Le statut de chaque partie est géré et affiché avec un code couleur.
*   **Assignation Automatique des Joueurs et Arbitres :** Les joueurs et arbitres sont assignés automatiquement aux simples.
*   **Composition des Doubles Modifiable :** Seules les parties en double sont modifiables par l'utilisateur.
*   **Navigation Contextuelle :** La navigation depuis une partie dépend de son type (simple ou double).
*   **Noms d'Équipes sur les Fiches de Partie :** Les noms réels des équipes sont affichés.

## Style et Conception

L'application utilise le framework Material Design de Flutter pour une apparence propre et cohérente.

## Plan Actuel

L'objectif est de finaliser l'application, en s'assurant que tout est fonctionnel et sans erreurs.

### Étapes Réalisées

1.  **Ajout du Bouton Retour :** Intégration d'un bouton de retour sur l'écran "Feuille des parties".
2.  **Correction de l'Affichage des Noms :** Résolution du bug qui empêchait l'affichage des noms des joueurs et arbitres.
3.  **Redirection vers les Fiches de Partie :** Modification du flux de navigation après la création d'une rencontre.
4.  **Saisie Automatique en Mode Débogage :** Implémentation du pré-remplissage automatique des données.
5.  **Affichage des Noms d'Équipes :** Remplacement des libellés génériques par les noms réels.
6.  **Pré-remplissage des parties et gestion des doubles :** Mise en place de la logique d'assignation.
7.  **Affichage des 14 parties et de leur statut :** Implémentation de la génération et de l'affichage des parties.
8.  **Corrections et Améliorations Diverses :** Résolution de bugs, de problèmes de compilation et d'incohérences logiques.
