Le dossier src contient les codes Octave/Matlab servant à la génération des fichier d'entrée du code TOYxDAC_TIME_V1.5_2015_12 spécifique à l'anisotropie : permet de générer (comme dans 2D_isotrope/src) les fichiers de milieux décrit par les paramètres d'anisotropie delta et epsilon de Thomsen.

Plus de détails sont donnés en commentaire, accessibles en tapant :
help nom_de_la_fonction

config.m est le programme principal appelant ces fonctions. Le chemin des fonctions doit être renseigné par la commande :
addpath('./src/')
ce qui peut être automatique au démarrage d'octave en l'ajoutant à ~/.octaverc






