# Modèles de grilles objectif

Tous les modèles vivent dans **`patterns.json`**, sous la clé `"patterns"` :
un tableau où chaque entrée est un modèle.

## Format

```json
{
  "patterns": [
    {
      "size": 4,
      "targetPattern": [
        [1, 1, 1, 1],
        [1, 0, 0, 1],
        [1, 0, 0, 1],
        [1, 1, 1, 1]
      ]
    },
    {
      "size": 5,
      "targetPattern": [
        [0, 0, 1, 0, 0],
        [0, 1, 1, 1, 0],
        [1, 1, 1, 1, 1],
        [0, 1, 1, 1, 0],
        [0, 0, 1, 0, 0]
      ]
    }
  ]
}
```

- `size` : taille de la grille (doit correspondre au nombre de lignes/colonnes de `targetPattern`).
- `targetPattern` : une matrice `size` × `size` de `1` (face) ou `0` (pile).

## Combien de modèles par taille ?

Autant que tu veux — le jeu en choisit un au hasard parmi tous ceux
disponibles pour la taille demandée à chaque niveau. Plus tu en ajoutes,
moins les mélanges se répètent.

## Tailles utilisées actuellement

D'après la table de progression : **4×4**, **5×5**, **6×6** (niveaux 1 à 18,
voir `claude.md`/`plan.md`). Tant qu'une taille n'a aucun modèle dans le
fichier, le jeu utilise automatiquement un modèle de secours (bordure face /
intérieur pile) pour rester jouable — pas besoin de tout écrire d'un coup.
