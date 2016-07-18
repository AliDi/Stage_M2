Le dossier src contient les codes Octave/Matlab servant à la génération des fichier d'entrée propres au code SEM3D_V1.2_2016_04 :

- src/acqui_generation_multielement_2trans_ELAS.m (génération du fichier d'acquisition semblable au cas isotrope, avec choix de la position de la sonde suivant la troisième dimension)
- src/acqui_generation_multielement_ELAS.m (génération du fichier d'acquisition semblable au cas isotrope, avec choix de la position de la sonde suivant la troisième dimension)

src/vs_inclusion_generation.m (inclusion avec changement de vitesse des ondes transversales)
src/vs_init_generation.m	(vitesse des ondes transversales uniforme)


Plus de détails sont donnés en commentaire, accessibles en tapant :
help nom_de_la_fonction

config.m est le programme principal appelant ces fonctions. Le chemin des fonctions doit être renseigné par la commande :
addpath('./src/')
ce qui peut être automatique au démarrage d'octave en l'ajoutant à ~/.octaverc






