#!/bin/bash
if (($#==2))			#verification du nb d'argument
then
	if [ -d "../sauvegardes/$1" ] 		#verification que le fichier n'existe pas
	then
		echo "ERREUR: le fichier existe deja!"
		echo "voulez-vous le remplacer?(O/N)"
		read choice
		if [[ $choice == "O" ]]
		then   
			echo "suppression du dossier de figure nommé $1 ."
			rm -R ./sauvegardes/$1
			echo "Création du nouveau repertoire de sauvegarde...."
		else
			echo "Arret du programme"
			exit 1
		fi
	else
	echo "Création du repertoire de sauvegarde..."
	fi

mkdir ../sauvegardes/$1

psimage $2 < gradient > image_gradient
psimage $2 < param_vp_inter > image_param_vp_inter
psimage $2 < param_vp_final > image_param_vp_final
	
cp * ../sauvegardes/$1

else
  echo "ERREUR: Il y a un problème d'argument => écrire un nom de dossier puis n1=..."	#erreur pour argument différent de 2
fi

echo "Archivage terminé"
exit 0
