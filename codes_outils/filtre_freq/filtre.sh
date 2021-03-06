#!/bin/bash

if (($#==4))			#verification du nb d argument
then
	
	########## sauvegarde des donnees originales ##########
	#cd ./data	
	for i in fsismos_P????
 		do cp $i filtre_${i}
	done
	
	cp fricker filtre_fricker
	
	########## filtrage a la frequence $1 ##########
	echo -e "$1 \n $2 \n $3 \n $4 \n" | octave --silent --no-window-system filtre_freq.m

	########## Affichage des donnees filtrees pour le couple 0-0 ##########
	n1=` wc fsismos_P0000 | awk '{print $3}'` 
	n2=$(($n1/$3/4))
	ximage < fsismos_P0000 n1=$n2 perc=99 title='Donnees mesurees' &
	ximage < filtre_fsismos_P0000 n1=$n2 perc=99 title='Donnees filtrees' &
	
	########## Affichage des excitations ##########
	#ximage < fricker n1=1 title='excitation originale'	&
	#ximage < filtre_fricker n1=1 title='excitation filtree' &
	
else
  echo "4 argument doivent être donnés (nombres séparés par des espaces) : Fréquence centrale du filtre + Nombre de sources + Nombre de récepteurs + Nombre de coefficients du filtre FIR"
fi

exit 0
