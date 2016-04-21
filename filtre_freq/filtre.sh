#!/bin/bash

if (($#==2))			#verification du nb d argument
then
	
	########## sauvegarde des donnees originales ##########
	cd ./data	
	for i in fsismos_P????
 		do cp $i filtre_${i}
	done
	
	cd ..	
	########## filtrage a la frequence $1 ##########
	echo -e "$1 \n $2 \n" | octave filtre_freq.m

	########## Affichage des donnees filtrees pour le couple 0-0 ##########
	n1=` wc ./data/fsismos_P0000 | awk '{print $3}'` 
	n2=$(($n1/$2/4))
	ximage < ./data/fsismos_P0000 n1=$n2 perc=99 title='Donnees mesurees' &
	ximage < ./data/filtre_fsismos_P0000 n1=$n2 perc=99 title='Donnees filtrees' &

else
  echo "Indique la frequence centrale du filtre et le nombre de sources "
fi

exit 0
