Le dossier src contient les codes Octave/Matlab servant à la génération des fichier d'entrée du code TOYxDAC_TIME_V1.5_2015_12 : 

Génération du fichier 'acqui_file' qui répertorie la position des sources et récepteurs : 
- acqui_generation.m (prend en entrée l'ensemble des coordonnées sources/récep)
- acqui_generation_multielement.m (prend en entrée la position du centre de la barrette source et la position du centre de la barrette réceptrice)
- acqui_generation_multielement_2trans.m (prend en entrée la position du centre de 2 barrettes source et de 2 barrettes réceptrices)
- acqui_generation_multielement_reflex_trans.m (prend en entrée la position du centre d'une barrette émettrice et de 2 barrettes réceptrices)

Génération de 'fricker' qui contient l'ondelette d'excitation : 
- fricker_generation.m

Génération des fichier de vitesse et masse volumique (pas optmisée puisque la même opération est effectuée par plusieurs fonctions, mais plus simple pour gérer les affichages) :
background.m (génère des milieux uniformes)
crack.m	(ajoute une fissure aux milieux donnés en entrée)
inclusion.m (ajoute une inclusion, i.e. un cercle, aux milieux donnés en entrée)
Ninclusions.m (ajoute N inclusions aux milieux donnés en entrée)
weld.m (ajoute une soudure en V aux milieux donnés en entrée)

Plus de détails sont donnés en commentaire, accessibles en tapant :
help nom_de_la_fonction

config.m est le programme principal appelant ces fonctions. Le chemin des fonctions doit être renseigné par la commande :
addpath('./src/')
ce qui peut être automatique au démarrage d'octave en l'ajoutant à ~/.octaverc






