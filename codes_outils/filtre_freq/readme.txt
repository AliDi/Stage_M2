programmes pour le filtrage des données et de l'excitation ( passe-bas)

Le scripts filtre.sh sert au filtrage passe bas des données. Il utilise le programme Octave filtre.m. Il prend comme argument la fréquence centrale du filtre en Hz, le nombre de sources, le nombre de récepteur et le nombre de coefficient pour le calcul du filtre FIR (nombre à diminuer quand on filtre de plus en plus haut en fréquence : 150 à 200kHz jusqu'à 10 à 4MHz).

ex : ./filtre.sh 200e3 64 64 150

Attention : le pas d'échantillonage temporel est à modifier dans le programme filtre.m (à la ligne 10 environ).