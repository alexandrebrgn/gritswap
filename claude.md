## Contexte : 
- J'aimerais créer un jeu mobile qui à terme sera mis sur playstore. 
- Je n'ai pas beaucoup voir très peu de compétences en développement mobile mais en développement en général je me débrouille. 
- J'ai 4 ans d'expérience dans le domaine du développement.

## Pourquoi :
- J'aimerais m'amuser et apprendre plus d'un ou plusieurs langage ou techno nécessaires que je ne connait pas que tu vas me conseiller.
- Faire mes premiers pas dans le monde du dév jeux mobiles

## But du jeu :
- Ce sera grandement inspiré d'un mini-jeu super mario bros DS mais pas une copie.

- Ce sera un jeu de rapidité avec un temps limite qui s'écoulera petit à petit en secondes. Lorsqu'un niveau est réussi on ajoute un temps qu'on choisira ensemble quand je testerais le jeu.

- Lorsque le jeu commence une grille n*n de carrés à deux faces différentes s'affiche, lorsque qu'on appuie sur un des carrés, il se retourne tous ainsi que tous les carrés autour donc au total 9 carrés maximum.

## Caractéristiques :

- Le but est de faire correspondre une grille mélangée à une grille objectif. Je pense que pour mélanger la grille, tu prendras la grille objectif et appuyer à 1  ou 3 endroits aléatoire en fonction de la diffculté et l'avancée dans le jeu.

- On peut appuyer sur un carré se trouvant sur les bords dans, ce cas là il y aura 6 carrés qui vont se retourner

- Si on appuie dans un coin, 4 carrés se retournent

- Un carré déja retourné peut être retourné à nouveau et ceci autant de fois voulues, dans la limite de retournement autorisées.

- La diffuclté s'améliorera au fur et à mesure.

- Un essi raté fera perdre légèrement du temps

- Si on prends l'exemple que lorsque l'objectif à été randomisé avec 1 seul coup, si le joueur s'est trompé, alors le modèle randomisé reviens à son point de départ (qui est bien sur différent de l'objectif).

## Possibilités d'évolutions :

- Casser le ryhtme à des intervalles régulières en proposant un autre mini-jeu qui aura un principe bien différent pour éviter l'ennui et la répétition.

- Proposer un système de récompenses en fin de partie (de l'argent), et une boutique pour offrir des visuels différents ou des petits gadgets à utiliser au début ou en fin de partie comme recommencer en rajoutant du temps.

## Evolution pendant la partie :

- ##### Les grilles seront proposées dans cet ordre:

|niveau|taille de la grille|nombre de retournements|
|--------|---|----|
|1|4*4|1|
|2|4*4|1|
|3|4*4|1|
|4|4*4|2|
|5|4*4|2|
|6|5*5|1|
|7|5*5|1|
|8|5*5|1|
|9|5*5|2|
|10|5*5|2|
|11|6*6|1|
|12|6*6|1|
|13|6*6|1|
|14|6*6|2|
|15|6*6|2|
|16|4*4|3|
|17|4*4|3|
|18|4*4|3|

Le reste il faudrait trouver ue suite logique avec une limite on peut envisager de passer en 3\*3 avce 3 ou en 6\*6

## Mes questions avant de commencer :

- est ce que je dois installer un émulateur android en particulier? Si oui lequel?

- Il va falloir qu'on trouve un système de création de modèles par exemple je voudrais écrire un modèle d'objectif comme ça pour une grille 4*4 :

```
****
*--*
*--*
****
```
Ce qui représente un grile avec les bords différents de l'intérieur, le * sera le coté face tandis que le - sera le coté pile.

- Les deux cotés seront stockés en local, et le système de skin à acheter avec l'argent récolté serivra à acheter différentes combinaisons dans la boutique.

## Dans la boutique :

- Skin de fond d'écran
- Skin de combinaison de faces de carrés

