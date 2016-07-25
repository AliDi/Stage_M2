Le dossier src contient les codes Octave/Matlab servant à la génération des fichier d'entrée propres au code SEM3D_V1.2_2016_04 :

- src/acqui_generation_multielement_2trans_ELAS.m (génération du fichier d'acquisition semblable au cas isotrope, avec choix de la position de la sonde suivant la troisième dimension)
- src/acqui_generation_multielement_ELAS.m (génération du fichier d'acquisition semblable au cas isotrope, avec choix de la position de la sonde suivant la troisième dimension)

-data_weighting : pour la pondération des données


Plus de détails sont donnés en commentaire, accessibles en tapant :
help nom_de_la_fonction

config.m est le programme appelant les fonctions de ./src/ et 2D_isotrope/src pour la génération d'un milieu anisotrope. Le chemin des fonctions doit être renseigné par la commande :
addpath('../2D_isotrope/src')
addpath('./src')
ce qui peut être automatique au démarrage d'octave en l'ajoutant à ~/.octaverc






