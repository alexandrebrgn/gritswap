# Plan de préparation — Jeu de grille (nom à trouver)

## 1. Rappel du concept

Un puzzle de rapidité inspiré d'un mini-jeu de Mario Bros DS :
- Grille n×n de carrés à deux faces (face `*` / pile `-`).
- Appuyer sur un carré retourne ce carré + ses voisins (jusqu'à 9 carrés au centre, 6 sur un bord, 4 dans un coin).
- But : faire correspondre la grille mélangée à une grille objectif, avant que le temps (qui décroît) n'arrive à zéro.
- Difficulté progressive : taille de grille et nombre de coups de mélange augmentent selon un tableau de niveaux déjà défini dans `claude.md`.
- Erreur = perte de temps légère, et le mélange revient à son état de départ (pas à l'objectif).
- Évolutions prévues : mini-jeu de rupture de rythme, monnaie de récompense, boutique de skins (fond d'écran, combinaisons de faces).

## 2. Décisions techniques

| Sujet | Choix | Pourquoi |
|---|---|---|
| Stack | **Flutter (Dart)** | Un seul codebase, animations riches (dont l'effet "flip 3D" que tu veux via `Transform`/`Matrix4`), bon support du stockage local et des achats intégrés, build Play Store simple. |
| Plateforme | **Android uniquement** | Colle à l'objectif Play Store, pas besoin de Mac. |
| Modèles de grille objectif | **JSON déclaratif** | Un fichier/objet par niveau : taille, motif cible, nombre de coups de mélange. Facile à versionner, valider, faire évoluer plus tard vers un éditeur visuel. |
| Gestion d'état | **Provider (ChangeNotifier)** | Solution simple et très documentée pour apprendre, suffisante pour la complexité du jeu. On pourra migrer vers Riverpod plus tard si besoin. |
| Stockage local | **shared_preferences** (progression, skins possédés, monnaie) | Suffisant pour des données simples clé/valeur, pas besoin d'une vraie DB au début. |
| Collaboration | **Tu codes, je guide** | Pair-programming pédagogique : je t'explique/te propose les étapes et extraits, tu écris et exécutes, on debug ensemble. |

## 3. Réponses à tes questions initiales

- **Émulateur Android** : pas besoin d'un émulateur tiers (Genymotion etc.). On utilise l'émulateur intégré à Android Studio (AVD). Ta machine a déjà `/dev/kvm` disponible, donc l'accélération matérielle devrait fonctionner — on vérifiera avec `flutter doctor` et un test d'accélération pendant le setup.
- **Système de modèles** : on part sur du JSON. Ton idée d'écrire les patterns en ASCII (`*`/`-`) reste une bonne idée comme **format d'auteur** — on pourra écrire un petit script de conversion ASCII → JSON plus tard si tu préfères continuer à dessiner tes niveaux à la main. Pas indispensable pour le MVP.

## 4. Setup de l'environnement (à faire ensemble, étape 1)

1. Installer Java (JDK 17, requis par Android Gradle Plugin récent).
2. Installer Android Studio (SDK Android, command-line tools, AVD Manager).
3. Créer un AVD (Pixel récent, API 34+) et vérifier l'accélération KVM.
4. Installer le SDK Flutter (canal stable) + ajouter au PATH.
5. `flutter doctor` → corriger les éventuels manques (licences Android, etc.).
6. Configurer VS Code (extensions Dart/Flutter) comme éditeur — plus léger qu'Android Studio pour coder au quotidien.
7. `flutter create` du projet, premier `flutter run` sur l'émulateur pour valider la chaîne complète.

## 5. Architecture du projet (cible)

```
projet-jeu/
  lib/
    main.dart
    models/
      grid.dart          # état d'une grille (matrice de bool face/pile)
      level.dart          # définition d'un niveau (taille, pattern, coups de mélange)
    game/
      grid_logic.dart     # retournement, propagation aux voisins, détection victoire
      shuffle.dart         # génération du mélange depuis l'objectif
      timer_controller.dart
    data/
      levels/*.json        # les modèles de grilles objectif par niveau
      level_repository.dart
      local_storage.dart   # progression, monnaie, skins (shared_preferences)
    ui/
      screens/
        game_screen.dart
        home_screen.dart
        shop_screen.dart    # plus tard
      widgets/
        grid_view.dart
        flip_tile.dart       # widget carré + animation flip 3D
        timer_bar.dart
    theme/
  test/
    grid_logic_test.dart
    shuffle_test.dart
```

## 6. Modèle de données (JSON) — première ébauche

```json
{
  "level": 1,
  "gridSize": 4,
  "shuffleMoves": 1,
  "targetPattern": [
    [1,1,1,1],
    [1,0,0,1],
    [1,0,0,1],
    [1,1,1,1]
  ],
  "timeBonusOnSuccess": 15
}
```
- `targetPattern` : `1` = face, `0` = pile (équivalent JSON de ton `*`/`-`).
- Le mélange à l'exécution : on part de `targetPattern` et on applique `shuffleMoves` retournements aléatoires (règle déjà définie dans `claude.md`).

## 7. Logique de jeu — points clés à implémenter

- Fonction pure `applyFlip(grid, row, col) → newGrid` (retourne la cellule + voisins existants, gère bords/coins).
- Génération du mélange : appliquer `shuffleMoves` flips aléatoires depuis `targetPattern`, en gardant en mémoire la séquence pour pouvoir "revenir au point de départ" en cas d'erreur (règle : un essai raté ramène au mélange initial, pas à l'objectif).
- Détection de victoire : grille courante == `targetPattern`.
- Timer qui décroît en secondes, + bonus de temps à la réussite d'un niveau, + petite pénalité de temps sur erreur.
- Le tout testable **sans UI** (logique pure Dart), ce qui permet d'écrire des tests unitaires solides avant même de toucher à l'affichage.

## 8. UI & animations

- Grille affichée en `GridView` (ou `Wrap`/`Table` selon rendu), responsive à n×n.
- Chaque carré = `FlipTile` : `AnimationController` + `Transform` avec `Matrix4.rotationY` et perspective (`setEntry(3, 2, 0.001)`) pour l'effet "3D" demandé, en restant un jeu 2D.
- Propagation visuelle : les carrés voisins s'animent avec un très léger décalage (stagger) pour un rendu plus vivant qu'un flip instantané synchrone.
- Barre de temps qui se vide progressivement (`timer_bar.dart`).

## 9. Roadmap de développement (milestones)

1. **Setup** — environnement + `flutter run` qui affiche "Hello".
2. **Logique pure** — modèles, flip, mélange, victoire, tests unitaires verts.
3. **UI statique** — grille affichée à partir d'un JSON, tap qui change l'état (sans animation).
4. **Animations** — flip 3D par carré + stagger sur les voisins.
5. **Boucle de jeu complète** — timer, progression de niveau selon le tableau de difficulté, écran de victoire/défaite.
6. **Persistance** — sauvegarde de la progression (niveau atteint, meilleur score) en local.
7. **Polish** — sons, transitions d'écran, réglages difficulté/UX suite à tes tests.
8. **Evolutions** (plus tard, hors MVP) — monnaie + boutique de skins, mini-jeu de rupture de rythme.
9. **Publication** — icône, fiche Play Store, signing/build de release, publication.

## 10. Décisions encore à prendre (pas bloquantes pour démarrer)

- Détail du système de monnaie/boutique (monnaie virtuelle uniquement, ou vrais achats in-app ?).
- Contenu précis du mini-jeu de rupture de rythme.
- Suite du tableau de niveaux au-delà du niveau 18 (mentionné comme "à trouver" dans `claude.md`).

On attaquera l'étape 1 (setup) à la prochaine session.
